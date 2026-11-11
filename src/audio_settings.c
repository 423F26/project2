#define _POSIX_C_SOURCE 200809L
#include "audio_settings.h"

#include <alsa/asoundlib.h>
#include <alloca.h>
#include <errno.h>
#include <limits.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

static bool fail(char *error, size_t size, const char *message)
{
    snprintf(error, size, "%s", message);
    return false;
}

bool audio_settings_validate(json_object *settings, char *error, size_t size)
{
    if(!settings || !json_object_is_type(settings, json_type_object) ||
       json_object_object_length(settings) == 0)
        return fail(error, size, "Provide an audio setting");
    json_object_object_foreach(settings, name, value) {
        if(strcmp(name, "muted") == 0) {
            if(!json_object_is_type(value, json_type_boolean))
                return fail(error, size, "muted must be true or false");
        } else if(strcmp(name, "volume_db") == 0 || strcmp(name, "input_gain_db") == 0) {
            if(!json_object_is_type(value, json_type_int) && !json_object_is_type(value, json_type_double))
                return fail(error, size, "Audio levels must be numbers in dB");
            double number = json_object_get_double(value);
            double minimum = strcmp(name, "volume_db") == 0 ? -60 : -12;
            double maximum = strcmp(name, "volume_db") == 0 ? 0 : 32;
            if(!isfinite(number) || number < minimum || number > maximum)
                return fail(error, size, "Output range is -60 to 0 dB; input gain is -12 to +32 dB");
        } else return fail(error, size, "Unknown audio setting");
    }
    return true;
}

static snd_mixer_elem_t *element(snd_mixer_t *mixer, const char *name)
{
    snd_mixer_selem_id_t *id;
    snd_mixer_selem_id_alloca(&id);
    snd_mixer_selem_id_set_index(id, 0);
    snd_mixer_selem_id_set_name(id, name);
    return snd_mixer_find_selem(mixer, id);
}

static snd_mixer_t *open_mixer(char *error, size_t size)
{
    snd_mixer_t *mixer = NULL;
    int code = snd_mixer_open(&mixer, 0);
    if(code >= 0) code = snd_mixer_attach(mixer, "hw:CARD=sndrpihifiberry");
    if(code >= 0) code = snd_mixer_selem_register(mixer, NULL, NULL);
    if(code >= 0) code = snd_mixer_load(mixer);
    if(code >= 0 && (!element(mixer, "Digital") || !element(mixer, "ADC"))) code = -ENODEV;
    if(code < 0) {
        snprintf(error, size, "ADAC interface unavailable: %s", snd_strerror(code));
        if(mixer) snd_mixer_close(mixer);
        return NULL;
    }
    return mixer;
}

static json_object *levels(snd_mixer_t *mixer)
{
    snd_mixer_elem_t *digital = element(mixer, "Digital"), *adc = element(mixer, "ADC");
    long volume = 0, gain = 0;
    int active = 1;
    if(snd_mixer_selem_get_playback_dB(digital, SND_MIXER_SCHN_FRONT_LEFT, &volume) < 0 ||
       snd_mixer_selem_get_capture_dB(adc, SND_MIXER_SCHN_FRONT_LEFT, &gain) < 0 ||
       snd_mixer_selem_get_playback_switch(digital, SND_MIXER_SCHN_FRONT_LEFT, &active) < 0) return NULL;
    json_object *result = json_object_new_object();
    json_object_object_add(result, "volume_db", json_object_new_double(volume / 100.0));
    json_object_object_add(result, "input_gain_db", json_object_new_double(gain / 100.0));
    json_object_object_add(result, "muted", json_object_new_boolean(!active));
    return result;
}

json_object *audio_settings_read(void)
{
    char error[160];
    snd_mixer_t *mixer = open_mixer(error, sizeof(error));
    json_object *result = mixer ? levels(mixer) : NULL;
    if(!result) {
        if(mixer) { snd_mixer_close(mixer); snprintf(error, sizeof(error), "Could not read ADAC mixer levels"); }
        result = json_object_new_object();
        json_object_object_add(result, "available", json_object_new_boolean(false));
        json_object_object_add(result, "error", json_object_new_string(error));
        return result;
    }
    json_object_object_add(result, "available", json_object_new_boolean(true));
    json_object_object_add(result, "name", json_object_new_string("HiFiBerry / ADAC"));
    const char *names[] = {"ADC Left Input", "ADC Right Input", "ADC Mic Bias"};
    const char *keys[] = {"left_input", "right_input", "mic_bias"};
    for(size_t i = 0; i < 3; ++i) {
        snd_mixer_elem_t *control = element(mixer, names[i]);
        unsigned item = 0;
        char text[80];
        if(control && snd_mixer_selem_get_enum_item(control, SND_MIXER_SCHN_FRONT_LEFT, &item) >= 0 &&
           snd_mixer_selem_get_enum_item_name(control, item, sizeof(text), text) >= 0)
            json_object_object_add(result, keys[i], json_object_new_string(text));
    }
    snd_mixer_close(mixer);
    FILE *file = fopen("/proc/asound/sndrpihifiberry/pcm0p/sub0/hw_params", "r");
    unsigned rate = 0, period = 0, buffer = 0;
    char line[160];
    while(file && fgets(line, sizeof(line), file)) {
        if(sscanf(line, "rate: %u", &rate) == 1) continue;
        if(sscanf(line, "period_size: %u", &period) == 1) continue;
        (void)sscanf(line, "buffer_size: %u", &buffer);
    }
    if(file) fclose(file);
    json_object_object_add(result, "rate", json_object_new_int64(rate));
    json_object_object_add(result, "period_frames", json_object_new_int64(period));
    json_object_object_add(result, "buffer_frames", json_object_new_int64(buffer));
    return result;
}

static bool config_path(char *path, size_t size)
{
    const char *config = getenv("XDG_CONFIG_HOME"), *home = getenv("HOME");
    int count;
    if(config && *config) count = snprintf(path, size, "%s/ml-guitar-pedal", config);
    else if(home && *home) count = snprintf(path, size, "%s/.config/ml-guitar-pedal", home);
    else return false;
    return count >= 0 && (size_t)count + strlen("/audio.json.tmp-2147483647") < size;
}

static bool save_levels(snd_mixer_t *mixer, char *error, size_t size)
{
    char directory[PATH_MAX], path[PATH_MAX + 64], temporary[PATH_MAX + 64];
    if(!config_path(directory, sizeof(directory))) return fail(error, size, "No audio settings directory");
    /* XDG_CONFIG_HOME's parent normally exists; create the default .config too. */
    char *slash = strrchr(directory, '/');
    if(slash) { *slash = '\0'; if(mkdir(directory, 0700) && errno != EEXIST) return fail(error, size, "Cannot create config directory"); *slash = '/'; }
    if(mkdir(directory, 0700) && errno != EEXIST) return fail(error, size, "Cannot create audio settings directory");
    snprintf(path, sizeof(path), "%s/audio.json", directory);
    snprintf(temporary, sizeof(temporary), "%s/audio.json.tmp-%ld", directory, (long)getpid());
    json_object *saved = levels(mixer);
    if(!saved) return fail(error, size, "Cannot read levels for saving");
    int code = json_object_to_file_ext(temporary, saved, JSON_C_TO_STRING_PRETTY);
    json_object_put(saved);
    if(code < 0 || rename(temporary, path)) {
        unlink(temporary);
        return fail(error, size, "Audio applied, but settings could not be saved");
    }
    return true;
}

static bool apply(json_object *settings, bool save, char *error, size_t size)
{
    if(!audio_settings_validate(settings, error, size)) return false;
    snd_mixer_t *mixer = open_mixer(error, size);
    if(!mixer) return false;
    json_object *value;
    int code = 0;
    if(json_object_object_get_ex(settings, "volume_db", &value))
        code = snd_mixer_selem_set_playback_dB_all(element(mixer, "Digital"), (long)lround(json_object_get_double(value) * 100), -1);
    if(code >= 0 && json_object_object_get_ex(settings, "input_gain_db", &value))
        code = snd_mixer_selem_set_capture_dB_all(element(mixer, "ADC"), (long)lround(json_object_get_double(value) * 100), -1);
    if(code >= 0 && json_object_object_get_ex(settings, "muted", &value))
        code = snd_mixer_selem_set_playback_switch_all(element(mixer, "Digital"), !json_object_get_boolean(value));
    bool ok = code >= 0;
    if(!ok) snprintf(error, size, "Could not apply audio setting: %s", snd_strerror(code));
    else if(save) ok = save_levels(mixer, error, size);
    snd_mixer_close(mixer);
    return ok;
}

bool audio_settings_apply(json_object *settings, char *error, size_t size)
{
    return apply(settings, true, error, size);
}

bool audio_settings_restore(char *error, size_t size)
{
    char path[PATH_MAX];
    if(!config_path(path, sizeof(path))) return fail(error, size, "No audio settings directory");
    strcat(path, "/audio.json");
    if(access(path, F_OK) && errno == ENOENT) return true;
    json_object *saved = json_object_from_file(path);
    bool ok = saved && apply(saved, false, error, size);
    if(!saved) fail(error, size, "Could not read saved audio settings");
    if(saved) json_object_put(saved);
    return ok;
}
