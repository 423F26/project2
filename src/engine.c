#define _POSIX_C_SOURCE 200809L
#include "pedal.h"

#include <alsa/asoundlib.h>
#include <errno.h>
#include <getopt.h>
#include <json-c/json.h>
#include <math.h>
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/select.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/un.h>
#include <time.h>
#include <unistd.h>

#define DEFAULT_SOCKET "/run/guitar-effect.sock"

static volatile sig_atomic_t running = 1;

static void stop(int unused)
{
    (void)unused;
    running = 0;
}

static void usage(FILE *stream)
{
    fprintf(stream, "Usage: pedal-engine [options]\n"
        "  --input DEVICE --output DEVICE   ALSA capture and playback\n"
        "  --rate HZ --block FRAMES          Defaults: 48000, 128\n"
        "  --drive N --tone HZ --mix N --level N\n"
        "  --fuzz-drive N --fuzz-tone HZ --fuzz-level N\n"
        "  --clean-level N --lv2 URI [--lv2 URI ...]\n"
        "  --list-devices --list-lv2 --meter\n"
        "  --socket PATH --no-audio          Test/control without ALSA\n");
}

static bool parse_number(const char *text, double *value)
{
    char *end;
    errno = 0;
    *value = strtod(text, &end);
    return end != text && *end == '\0' && errno == 0 && isfinite(*value);
}

static void device_names(char *capture, size_t capture_size, char *playback, size_t playback_size,
                         const char *preferred)
{
    FILE *file = fopen("/proc/asound/pcm", "r");
    if(!file) return;
    char line[512];
    while(fgets(line, sizeof(line), file)) {
        unsigned card, device;
        if(sscanf(line, "%u-%u:", &card, &device) != 2) continue;
        char name[64];
        snprintf(name, sizeof(name), "plughw:%u,%u", card, device);
        if(strstr(line, "capture") && !*capture) snprintf(capture, capture_size, "%s", name);
        if(strstr(line, "playback") && !*playback)
            snprintf(playback, playback_size, "%s", name);
    }
    const char *wanted = preferred ? preferred : capture;
    if(wanted && *wanted) {
        rewind(file);
        while(fgets(line, sizeof(line), file)) {
            unsigned card, device;
            if(sscanf(line, "%u-%u:", &card, &device) != 2 || !strstr(line, "playback")) continue;
            char name[64];
            snprintf(name, sizeof(name), "plughw:%u,%u", card, device);
            if(strcmp(name, wanted) == 0) {
                snprintf(playback, playback_size, "%s", name);
                break;
            }
        }
    }
    fclose(file);
}

static void list_devices(void)
{
    FILE *file = fopen("/proc/asound/pcm", "r");
    printf("capture:");
    if(file) {
        char line[512];
        while(fgets(line, sizeof(line), file)) {
            unsigned card, device;
            if(sscanf(line, "%u-%u:", &card, &device) == 2 && strstr(line, "capture"))
                printf(" plughw:%u,%u", card, device);
        }
        rewind(file);
        printf("\nplayback:");
        while(fgets(line, sizeof(line), file)) {
            unsigned card, device;
            if(sscanf(line, "%u-%u:", &card, &device) == 2 && strstr(line, "playback"))
                printf(" plughw:%u,%u", card, device);
        }
        fclose(file);
    } else printf("\nplayback:");
    printf("\n");
}

static json_object *settings(const Pedal *pedal)
{
    json_object *object = json_object_new_object();
#define SET(field) json_object_object_add(object, #field, json_object_new_double(pedal->field))
    if(pedal->kind == OVERDRIVE) { SET(drive); SET(tone); SET(mix); SET(level); }
    if(pedal->kind == FUZZ) { SET(drive); SET(tone); SET(level); }
    if(pedal->kind == DELAY) { SET(time); SET(feedback); SET(mix); }
    if(pedal->kind == TREMOLO) { SET(rate); SET(depth); }
    if(pedal->kind == CHORUS) { SET(rate); SET(depth); SET(mix); }
#undef SET
    if(pedal->kind == LV2)
        for(size_t i = 0; i < pedal->control_count; ++i)
            if(pedal->controls[i].input)
                json_object_object_add(object, pedal->controls[i].symbol,
                                       json_object_new_double(pedal->controls[i].value));
    return object;
}

static json_object *state(Engine *engine)
{
    json_object *root = json_object_new_object();
    json_object_object_add(root, "enabled", json_object_new_boolean(engine->enabled));
    json_object_object_add(root, "amount", json_object_new_double(engine->amount));
    json_object *pedals = json_object_new_array();
    for(size_t i = 0; i < engine->active_count; ++i)
        json_object_array_add(pedals, json_object_new_string(engine->pedals[engine->active[i]].id));
    json_object_object_add(root, "pedals", pedals);
    json_object *all_settings = json_object_new_object();
    json_object *available = json_object_new_object();
    for(size_t i = 0; i < engine->pedal_count; ++i) {
        Pedal *pedal = &engine->pedals[i];
        json_object *config = settings(pedal);
        json_object_object_add(all_settings, pedal->id, json_object_get(config));
        json_object *info = json_object_new_object();
        json_object_object_add(info, "name", json_object_new_string(pedal->name));
        json_object_object_add(info, "settings", config);
        json_object_object_add(info, "uri", pedal->kind == LV2 ? json_object_new_string(pedal->uri) : NULL);
        json_object *ranges = json_object_new_object();
        if(pedal->kind == LV2)
            for(size_t p = 0; p < pedal->control_count; ++p) {
                ControlPort *port = &pedal->controls[p];
                if(!port->input) continue;
                json_object *range = json_object_new_object();
                json_object_object_add(range, "min", port->has_minimum ? json_object_new_double(port->minimum) : NULL);
                json_object_object_add(range, "max", port->has_maximum ? json_object_new_double(port->maximum) : NULL);
                json_object_object_add(ranges, port->symbol, range);
            }
        json_object_object_add(info, "ranges", ranges);
        json_object_object_add(available, pedal->id, info);
    }
    json_object_object_add(root, "settings", all_settings);
    json_object_object_add(root, "available", available);
    return root;
}

static json_object *lv2_listing(Engine *engine)
{
    json_object *root = json_object_new_object();
    json_object *plugins = json_object_new_array();
    const LilvPlugins *all = lilv_world_get_all_plugins(engine->world);
    LILV_FOREACH(plugins, iterator, all) {
        const LilvPlugin *plugin = lilv_plugins_get(all, iterator);
        if(!lv2_compatible(engine, plugin)) continue;
        const char *uri = lilv_node_as_uri(lilv_plugin_get_uri(plugin));
        LilvNode *name = lilv_plugin_get_name(plugin);
        json_object *entry = json_object_new_object();
        json_object_object_add(entry, "uri", json_object_new_string(uri));
        json_object_object_add(entry, "name", json_object_new_string(name ? lilv_node_as_string(name) : uri));
        if(name) lilv_node_free(name);
        const char *loaded = NULL;
        for(size_t i = 5; i < engine->pedal_count; ++i)
            if(strcmp(engine->pedals[i].uri, uri) == 0) loaded = engine->pedals[i].id;
        json_object_object_add(entry, "loaded_as", loaded ? json_object_new_string(loaded) : NULL);
        json_object_array_add(plugins, entry);
    }
    json_object_object_add(root, "plugins", plugins);
    return root;
}

static bool parse_board(Engine *engine, const char *text, size_t *indices, size_t *count)
{
    *count = 0;
    if(strcmp(text, "-") == 0) return true;
    char copy[4096];
    size_t length = strlen(text);
    if(!length || length >= sizeof(copy) || text[0] == ',' || text[length - 1] == ',' || strstr(text, ",,")) return false;
    strcpy(copy, text);
    char *save = NULL;
    for(char *part = strtok_r(copy, ",", &save); part; part = strtok_r(NULL, ",", &save)) {
        if(*count == MAX_ACTIVE) return false;
        {
            Pedal *pedal = engine_find(engine, part);
            if(!pedal) return false;
            indices[(*count)++] = (size_t)(pedal - engine->pedals);
        }
    }
    for(size_t i = 0; i < *count; ++i)
        for(size_t j = 0; j < i; ++j) if(indices[i] == indices[j]) return false;
    return true;
}

static char *reply_command(Engine *engine, const char *command)
{
    char error[256] = "invalid command";
    json_object *result = NULL;
    if(strcmp(command, "state") == 0) result = state(engine);
    else if(strcmp(command, "lv2-list") == 0) {
        if(lv2_world_init(engine)) result = lv2_listing(engine);
        else snprintf(error, sizeof(error), "could not initialize Lilv");
    } else if(strncmp(command, "lv2-load ", 9) == 0) {
        if(lv2_load(engine, command + 9, error, sizeof(error))) result = state(engine);
    } else if(strcmp(command, "status") == 0 || strcmp(command, "clean") == 0 ||
              strcmp(command, "effect") == 0 || strcmp(command, "toggle") == 0) {
        if(strcmp(command, "clean") == 0) engine->enabled = false;
        if(strcmp(command, "effect") == 0) engine->enabled = true;
        if(strcmp(command, "toggle") == 0) engine->enabled = !engine->enabled;
        engine->target = engine->enabled ? engine->amount : 0;
        return strdup(engine->enabled ? "effect\n" : "clean\n");
    } else if(strncmp(command, "amount ", 7) == 0) {
        double value;
        if(parse_number(command + 7, &value) && value >= 0 && value <= 1) {
            engine->amount = value;
            engine->target = engine->enabled ? value : 0;
            result = state(engine);
        } else snprintf(error, sizeof(error), "amount must be between 0 and 1");
    } else if(strncmp(command, "board ", 6) == 0) {
        size_t indices[MAX_ACTIVE], count;
        if(!parse_board(engine, command + 6, indices, &count))
            snprintf(error, sizeof(error), "invalid pedal board");
        else {
            if(engine_set_board(engine, indices, count)) result = state(engine);
            else snprintf(error, sizeof(error), "could not set board");
        }
    } else if(strncmp(command, "config ", 7) == 0) {
        char id[32], setting[96], number[128], extra;
        double value;
        if(sscanf(command + 7, "%31s %95s %127s %c", id, setting, number, &extra) == 3 &&
           parse_number(number, &value) && engine_config(engine, engine_find(engine, id), setting, value))
            result = state(engine);
        else snprintf(error, sizeof(error), "invalid pedal setting");
    }
    if(result) {
        const char *serialized = json_object_to_json_string_ext(result, JSON_C_TO_STRING_PLAIN);
        size_t length = strlen(serialized);
        char *reply = malloc(length + 2);
        if(reply) {
            memcpy(reply, serialized, length);
            reply[length] = '\n';
            reply[length + 1] = '\0';
        }
        json_object_put(result);
        return reply;
    }
    char message[sizeof(error) + 16];
    snprintf(message, sizeof(message), "error: %s\n", error);
    return strdup(message);
}

static int open_control(const char *path)
{
    if(strlen(path) >= sizeof(((struct sockaddr_un *)0)->sun_path)) return -1;
    struct stat info;
    if(lstat(path, &info) == 0) {
        if(!S_ISSOCK(info.st_mode)) return -1;
        int probe = socket(AF_UNIX, SOCK_STREAM, 0);
        struct sockaddr_un address = {.sun_family = AF_UNIX};
        snprintf(address.sun_path, sizeof(address.sun_path), "%s", path);
        int active = connect(probe, (struct sockaddr *)&address, sizeof(address)) == 0;
        close(probe);
        if(active) { errno = EADDRINUSE; return -1; }
        if(unlink(path) < 0) return -1;
    }
    int listener = socket(AF_UNIX, SOCK_STREAM, 0);
    if(listener < 0) return -1;
    struct sockaddr_un address = {.sun_family = AF_UNIX};
    snprintf(address.sun_path, sizeof(address.sun_path), "%s", path);
    if(bind(listener, (struct sockaddr *)&address, sizeof(address)) < 0 || listen(listener, 8) < 0) {
        close(listener);
        return -1;
    }
    return listener;
}

static void poll_control(Engine *engine, int listener)
{
    fd_set readable;
    FD_ZERO(&readable);
    FD_SET(listener, &readable);
    struct timeval timeout = {0, 0};
    if(select(listener + 1, &readable, NULL, NULL, &timeout) != 1) return;
    int client = accept(listener, NULL, NULL);
    if(client < 0) return;
    struct timeval receive_timeout = {0, 10000};
    setsockopt(client, SOL_SOCKET, SO_RCVTIMEO, &receive_timeout, sizeof(receive_timeout));
    char command[4096];
    ssize_t length = recv(client, command, sizeof(command) - 1, 0);
    if(length > 0) {
        command[length] = '\0';
        command[strcspn(command, "\r\n")] = '\0';
        char *reply = reply_command(engine, command);
        if(reply) {
            size_t remaining = strlen(reply), offset = 0;
            while(remaining) {
                ssize_t sent = send(client, reply + offset, remaining, MSG_NOSIGNAL);
                if(sent <= 0) break;
                offset += (size_t)sent;
                remaining -= (size_t)sent;
            }
            free(reply);
        }
    }
    close(client);
}

static snd_pcm_t *open_pcm(const char *device, snd_pcm_stream_t stream, int rate, size_t block)
{
    snd_pcm_t *pcm = NULL;
    int code = snd_pcm_open(&pcm, device, stream, 0);
    if(code < 0) { fprintf(stderr, "ALSA %s: %s\n", device, snd_strerror(code)); return NULL; }
    unsigned latency = (unsigned)fmax(10000, block * 4000000.0 / rate);
    code = snd_pcm_set_params(pcm, SND_PCM_FORMAT_S16_LE, SND_PCM_ACCESS_RW_INTERLEAVED,
                              1, (unsigned)rate, 1, latency);
    if(code < 0) {
        fprintf(stderr, "ALSA %s: %s\n", device, snd_strerror(code));
        snd_pcm_close(pcm);
        return NULL;
    }
    return pcm;
}

static bool audio_loop(Engine *engine, const char *input_device, const char *output_device,
                       int listener, bool meter)
{
    snd_pcm_t *capture = open_pcm(input_device, SND_PCM_STREAM_CAPTURE, engine->rate, engine->block);
    if(!capture) return false;
    snd_pcm_t *playback = open_pcm(output_device, SND_PCM_STREAM_PLAYBACK, engine->rate, engine->block);
    if(!playback) { snd_pcm_close(capture); return false; }
    int16_t *input = calloc(engine->block, sizeof(int16_t));
    int16_t *output = calloc(engine->block, sizeof(int16_t));
    if(!input || !output) { free(input); free(output); snd_pcm_close(capture); snd_pcm_close(playback); return false; }
    unsigned capture_recoveries = 0, playback_recoveries = 0;
    size_t frames = 0;
    double squares = 0;
    int peak = 0;
    bool success = true;
    printf("guitar effect: %s -> %s; mode=effect; Ctrl+C to stop\n", input_device, output_device);
    fflush(stdout);
    while(running) {
        poll_control(engine, listener);
        snd_pcm_sframes_t got = snd_pcm_readi(capture, input, engine->block);
        if(got < 0) {
            capture_recoveries++;
            if(snd_pcm_recover(capture, (int)got, 1) < 0) { success = false; break; }
            continue;
        }
        if(got == 0) continue;
        if(meter) {
            for(snd_pcm_sframes_t i = 0; i < got; ++i) {
                double sample = input[i] / 32768.0;
                squares += sample * sample;
                int amplitude = abs(input[i]);
                if(amplitude > peak) peak = amplitude;
            }
            frames += (size_t)got;
            if(frames >= (size_t)engine->rate * 2) {
                printf("input rms=%.4f peak=%.4f capture_recoveries=%u playback_recoveries=%u\n",
                       sqrt(squares / frames), peak / 32768.0, capture_recoveries, playback_recoveries);
                fflush(stdout);
                frames = 0; squares = 0; peak = 0;
            }
        }
        engine_process(engine, input, output, (size_t)got);
        size_t written = 0;
        while(written < (size_t)got && running) {
            snd_pcm_sframes_t count = snd_pcm_writei(playback, output + written, (size_t)got - written);
            if(count < 0) {
                playback_recoveries++;
                if(snd_pcm_recover(playback, (int)count, 1) < 0) { success = false; running = 0; break; }
            } else if(count == 0) snd_pcm_wait(playback, 100);
            else written += (size_t)count;
        }
    }
    free(input); free(output);
    snd_pcm_close(capture); snd_pcm_close(playback);
    return success;
}

int main(int argc, char **argv)
{
    const char *input_arg = NULL, *output_arg = NULL;
    const char *socket_path = getenv("PEDAL_CONTROL_SOCKET");
    if(!socket_path || !*socket_path) socket_path = DEFAULT_SOCKET;
    const char *uris[MAX_ACTIVE];
    size_t uri_count = 0;
    int rate = 48000;
    size_t block = 128;
    bool show_devices = false, show_lv2 = false, meter = false, no_audio = false;
    double drive = 20, tone = 3000, mix = 1, level = .5;
    double fuzz_drive = 15, fuzz_tone = 2500, fuzz_level = .45, clean_level = 1;
    static const struct option options[] = {
        {"input", required_argument, NULL, 'i'}, {"output", required_argument, NULL, 'o'},
        {"rate", required_argument, NULL, 'r'}, {"block", required_argument, NULL, 'b'},
        {"drive", required_argument, NULL, 1}, {"tone", required_argument, NULL, 2},
        {"mix", required_argument, NULL, 3}, {"level", required_argument, NULL, 4},
        {"fuzz-drive", required_argument, NULL, 5}, {"fuzz-tone", required_argument, NULL, 6},
        {"fuzz-level", required_argument, NULL, 7}, {"clean-level", required_argument, NULL, 8},
        {"lv2", required_argument, NULL, 9}, {"socket", required_argument, NULL, 10},
        {"list-devices", no_argument, NULL, 11}, {"list-lv2", no_argument, NULL, 12},
        {"meter", no_argument, NULL, 13}, {"no-audio", no_argument, NULL, 14},
        {"help", no_argument, NULL, 'h'}, {0, 0, 0, 0}
    };
    int option;
    while((option = getopt_long(argc, argv, "hi:o:r:b:", options, NULL)) != -1) {
        double value;
        switch(option) {
        case 'h': usage(stdout); return 0;
        case 'i': input_arg = optarg; break;
        case 'o': output_arg = optarg; break;
        case 'r': if(!parse_number(optarg, &value) || value != floor(value) || value < 8000 || value > 192000) goto invalid; rate = (int)value; break;
        case 'b': if(!parse_number(optarg, &value) || value != floor(value) || value < 16 || value > MAX_BLOCK) goto invalid; block = (size_t)value; break;
        case 1: if(!parse_number(optarg, &drive)) goto invalid; break;
        case 2: if(!parse_number(optarg, &tone)) goto invalid; break;
        case 3: if(!parse_number(optarg, &mix)) goto invalid; break;
        case 4: if(!parse_number(optarg, &level)) goto invalid; break;
        case 5: if(!parse_number(optarg, &fuzz_drive)) goto invalid; break;
        case 6: if(!parse_number(optarg, &fuzz_tone)) goto invalid; break;
        case 7: if(!parse_number(optarg, &fuzz_level)) goto invalid; break;
        case 8: if(!parse_number(optarg, &clean_level)) goto invalid; break;
        case 9: if(uri_count == MAX_ACTIVE) goto invalid; uris[uri_count++] = optarg; break;
        case 10: socket_path = optarg; break;
        case 11: show_devices = true; break;
        case 12: show_lv2 = true; break;
        case 13: meter = true; break;
        case 14: no_audio = true; break;
        default: goto invalid;
        }
    }
    if(optind != argc || rate < 8000 || rate > 192000 || block < 16 || block > MAX_BLOCK ||
       drive < 1 || drive > 100 || tone < 100 || tone >= rate / 2.0 ||
       mix < 0 || mix > 1 || level < 0 || level > 1 || fuzz_drive < 1 || fuzz_drive > 100 ||
       fuzz_tone < 100 || fuzz_tone >= rate / 2.0 || fuzz_level < 0 || fuzz_level > 1 ||
       clean_level < 0 || clean_level > 1) goto invalid;
    if(show_devices) { list_devices(); return 0; }
    Engine *engine = calloc(1, sizeof(*engine));
    if(!engine || !engine_init(engine, rate, block, clean_level)) {
        fprintf(stderr, "could not initialize pedal engine\n");
        free(engine);
        return 1;
    }
    if(show_lv2) {
        if(!lv2_world_init(engine)) { engine_free(engine); free(engine); return 1; }
        const LilvPlugins *all = lilv_world_get_all_plugins(engine->world);
        LILV_FOREACH(plugins, iterator, all) {
            const LilvPlugin *plugin = lilv_plugins_get(all, iterator);
            if(!lv2_compatible(engine, plugin)) continue;
            LilvNode *name = lilv_plugin_get_name(plugin);
            printf("%s\t%s\n", name ? lilv_node_as_string(name) : "", lilv_node_as_uri(lilv_plugin_get_uri(plugin)));
            if(name) lilv_node_free(name);
        }
        engine_free(engine); free(engine); return 0;
    }
    engine->pedals[0].drive = drive;
    engine->pedals[0].tone = tone;
    engine->pedals[0].mix = mix;
    engine->pedals[0].level = level;
    engine->pedals[0].alpha = 1 - exp(-2 * 3.14159265358979323846 * tone / rate);
    engine->pedals[1].drive = fuzz_drive;
    engine->pedals[1].tone = fuzz_tone;
    engine->pedals[1].level = fuzz_level;
    engine->pedals[1].alpha = 1 - exp(-2 * 3.14159265358979323846 * fuzz_tone / rate);
    for(size_t i = 0; i < uri_count; ++i) {
        char error[256] = "";
        if(!lv2_load(engine, uris[i], error, sizeof(error))) {
            fprintf(stderr, "LV2 %s: %s\n", uris[i], error);
            engine_free(engine); free(engine); return 1;
        }
    }
    int listener = open_control(socket_path);
    if(listener < 0) {
        fprintf(stderr, "could not bind control socket %s: %s\n", socket_path, strerror(errno));
        engine_free(engine); free(engine); return 1;
    }
    struct sigaction action = {.sa_handler = stop};
    sigemptyset(&action.sa_mask);
    sigaction(SIGINT, &action, NULL);
    sigaction(SIGTERM, &action, NULL);
    bool success = true;
    if(no_audio) {
        while(running) {
            poll_control(engine, listener);
            struct timespec pause = {0, 1000000};
            nanosleep(&pause, NULL);
        }
    } else {
        char capture[64] = "", playback[64] = "";
        device_names(capture, sizeof(capture), playback, sizeof(playback), input_arg);
        const char *input = input_arg ? input_arg : capture;
        const char *output = output_arg ? output_arg : (strcmp(input, playback) == 0 ? input : playback);
        if(!*input || !*output) {
            fprintf(stderr, "no ALSA capture or playback device found; use --list-devices\n");
            success = false;
        } else success = audio_loop(engine, input, output, listener, meter);
    }
    close(listener);
    unlink(socket_path);
    engine_free(engine);
    free(engine);
    return success ? 0 : 1;
invalid:
    usage(stderr);
    return 2;
}
