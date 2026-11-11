#define _POSIX_C_SOURCE 200809L
#include "encoder_input.h"
#include "socket_client.h"

#include <errno.h>
#include <fcntl.h>
#include <linux/gpio.h>
#include <poll.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <time.h>
#include <unistd.h>

/* BCM GPIO numbers. These are exclusively inputs, never the ADAC I2C/I2S pins. */
static const unsigned offsets[] = {23, 24, 25};
static volatile sig_atomic_t running = 1;
static void stop(int unused) { (void)unused; running = 0; }

static uint64_t now_ns(void)
{
    struct timespec time;
    clock_gettime(CLOCK_MONOTONIC, &time);
    return (uint64_t)time.tv_sec * 1000000000 + (uint64_t)time.tv_nsec;
}

static bool send_action(const char *command)
{
    char *reply = pedal_send(command);
    bool ok = reply && strncmp(reply, "error:", 6) != 0;
    if(!ok) fprintf(stderr, "Encoder: %s: %s", command, reply ? reply : "engine unavailable\n");
    free(reply);
    return ok;
}

static int request_inputs(const char *path)
{
    int chip = open(path, O_RDONLY | O_CLOEXEC);
    if(chip < 0) return -1;
    for(size_t i = 0; i < 3; ++i) {
        struct gpio_v2_line_info info = {.offset = offsets[i]};
        char expected[16];
        snprintf(expected, sizeof(expected), "GPIO%u", offsets[i]);
        if(ioctl(chip, GPIO_V2_GET_LINEINFO_IOCTL, &info) < 0 ||
           strcmp(info.name, expected) != 0 || (info.flags & GPIO_V2_LINE_FLAG_USED)) {
            fprintf(stderr, "Encoder: %s must be a free header input on %s\n", expected, path);
            close(chip);
            errno = EBUSY;
            return -1;
        }
    }
    struct gpio_v2_line_request request = {.num_lines = 3, .event_buffer_size = 256};
    memcpy(request.offsets, offsets, sizeof(offsets));
    snprintf(request.consumer, sizeof(request.consumer), "riffline-encoder");
    request.config.flags = GPIO_V2_LINE_FLAG_INPUT | GPIO_V2_LINE_FLAG_BIAS_PULL_UP |
                           GPIO_V2_LINE_FLAG_EDGE_RISING | GPIO_V2_LINE_FLAG_EDGE_FALLING;
    int result = ioctl(chip, GPIO_V2_GET_LINE_IOCTL, &request);
    close(chip);
    if(result == 0 && fcntl(request.fd, F_SETFL, O_NONBLOCK) < 0) {
        close(request.fd);
        return -1;
    }
    return result < 0 ? -1 : request.fd;
}

static bool sample_inputs(int fd, unsigned *bits)
{
    struct gpio_v2_line_values values = {.mask = 7};
    if(ioctl(fd, GPIO_V2_LINE_GET_VALUES_IOCTL, &values) < 0) return false;
    *bits = (unsigned)values.bits & 7;
    return true;
}

static unsigned ab_state(unsigned bits) { return ((bits & 1) << 1) | ((bits >> 1) & 1); }

static bool deliver(int *steps, bool press, bool reverse)
{
    bool ok = true;
    if(*steps) {
        char command[48];
        int amount = reverse ? -*steps : *steps;
        if(amount > 1000) amount = 1000;
        if(amount < -1000) amount = -1000;
        snprintf(command, sizeof(command), "encoder turn %d", amount);
        ok = send_action(command);
        if(ok) fprintf(stderr, "Encoder: turn %+d\n", amount);
        *steps = 0;
    }
    if(press) {
        bool applied = send_action("encoder press");
        if(applied) fprintf(stderr, "Encoder: button pressed\n");
        ok = applied && ok;
    }
    return ok;
}

/* Deterministic integration tests without claiming any GPIO: ms A B button_level. */
static int replay(const char *path, unsigned edges_per_step, bool reverse)
{
    FILE *file = fopen(path, "r");
    if(!file) { perror(path); return 1; }
    EncoderInput decoder;
    unsigned a, b, button;
    unsigned long long ms, previous = 0;
    bool initialized = false;
    int pending = 0, result = 0;
    char line[128], extra;
    while(fgets(line, sizeof(line), file)) {
        if(line[0] == '#' || line[0] == '\n') continue;
        if(sscanf(line, "%llu %u %u %u %c", &ms, &a, &b, &button, &extra) != 4 ||
           a > 1 || b > 1 || button > 1 || ms < previous || ms > UINT64_MAX / 1000000) {
            fprintf(stderr, "Invalid replay sample\n"); result = 2; break;
        }
        previous = ms;
        if(!initialized) { encoder_input_init(&decoder, (a << 1) | b, !button, edges_per_step, ms * 1000000); initialized = true; }
        else {
            EncoderAction action = encoder_input_sample(&decoder, (a << 1) | b, !button, ms * 1000000);
            pending += action.steps;
            if(!deliver(&pending, action.press, reverse)) { result = 1; break; }
        }
    }
    fclose(file);
    return initialized ? result : 2;
}

int main(int argc, char **argv)
{
    const char *chip = "/dev/gpiochip0", *replay_path = NULL;
    bool reverse = false;
    unsigned edges_per_step = 4;
    for(int i = 1; i < argc; ++i) {
        if(strcmp(argv[i], "--chip") == 0 && i + 1 < argc) chip = argv[++i];
        else if(strcmp(argv[i], "--reverse") == 0) reverse = true;
        else if(strcmp(argv[i], "--edges-per-step") == 0 && i + 1 < argc &&
                (strcmp(argv[i+1], "2") == 0 || strcmp(argv[i+1], "4") == 0)) edges_per_step = (unsigned)atoi(argv[++i]);
        else if(strcmp(argv[i], "--replay") == 0 && i + 1 < argc) replay_path = argv[++i];
        else { fprintf(stderr, "Usage: pedal-encoder [--chip /dev/gpiochip0] [--reverse] [--edges-per-step 2|4] [--replay FILE]\n"); return 2; }
    }
    if(replay_path) return replay(replay_path, edges_per_step, reverse);
    signal(SIGINT, stop); signal(SIGTERM, stop);
    int fd = request_inputs(chip);
    if(fd < 0) { perror("Encoder GPIO inputs unavailable"); return 1; }
    unsigned bits;
    if(!sample_inputs(fd, &bits)) { perror("Encoder initial read"); close(fd); return 1; }
    uint64_t sampled_at = now_ns(), last_send = sampled_at, last_heartbeat = 0;
    EncoderInput decoder;
    encoder_input_init(&decoder, ab_state(bits), !(bits & 4), edges_per_step, sampled_at);
    fprintf(stderr, "Encoder listening: GPIO23=A GPIO24=B GPIO25=button, input pull-ups, %u edges/step%s\n",
            edges_per_step, reverse ? ", reversed" : "");
    int pending = 0, result = 0;
    uint32_t sequence = 0;
    while(running) {
        struct pollfd item = {.fd = fd, .events = POLLIN};
        int ready = poll(&item, 1, 10);
        if(ready < 0 && errno == EINTR) continue;
        if(ready < 0 || (item.revents & (POLLERR | POLLHUP | POLLNVAL))) { result = 1; break; }
        unsigned presses = 0;
        if(ready > 0) {
            struct gpio_v2_line_event events[64];
            ssize_t bytes;
            while((bytes = read(fd, events, sizeof(events))) > 0) {
                if(bytes % sizeof(events[0])) { result = 1; break; }
                for(size_t i = 0; i < (size_t)bytes / sizeof(events[0]); ++i) {
                    struct gpio_v2_line_event *event = &events[i];
                    bool gap = sequence && event->seqno != sequence + 1;
                    sequence = event->seqno;
                    if(gap) {
                        fprintf(stderr, "Encoder event overflow; resynchronizing inputs\n");
                        if(!sample_inputs(fd, &bits)) { result = 1; break; }
                        sampled_at = now_ns(); pending = 0; presses = 0;
                        encoder_input_init(&decoder, ab_state(bits), !(bits & 4), edges_per_step, sampled_at);
                    }
                    if(event->timestamp_ns <= sampled_at) continue;
                    int index = event->offset == 23 ? 0 : event->offset == 24 ? 1 : event->offset == 25 ? 2 : -1;
                    if(index < 0) continue;
                    if(event->id == GPIO_V2_LINE_EVENT_RISING_EDGE) bits |= 1U << index;
                    else bits &= ~(1U << index);
                    EncoderAction action = encoder_input_sample(&decoder, ab_state(bits), !(bits & 4), event->timestamp_ns);
                    pending += action.steps;
                    if(action.press) presses++;
                }
                if(result) break;
            }
            if(bytes == 0 || (bytes < 0 && errno != EAGAIN && errno != EINTR)) { result = 1; break; }
        }
        if(result) break;
        uint64_t time = now_ns();
        EncoderAction action = encoder_input_sample(&decoder, ab_state(bits), !(bits & 4), time);
        if(pending && time - last_send >= 40000000) { deliver(&pending, false, reverse); last_send = time; }
        if(action.press) presses++;
        while(presses > 0) { deliver(&pending, true, reverse); presses--; }
        if(time - last_heartbeat >= 1000000000) { send_action("encoder heartbeat"); last_heartbeat = time; }
    }
    close(fd);
    send_action("encoder disconnect");
    return result;
}
