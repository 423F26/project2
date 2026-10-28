#include "tuner.h"

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define PI 3.14159265358979323846
#define CHECK(condition) do { if(!(condition)) { \
    fprintf(stderr, "check failed: %s at line %d\n", #condition, __LINE__); exit(1); \
} } while(0)

static void feed(Tuner *tuner, double hz, double seconds, double amplitude)
{
    int16_t block[128];
    size_t frames = (size_t)(seconds * tuner->sample_rate);
    for(size_t start = 0; start < frames; start += 128) {
        size_t count = frames - start < 128 ? frames - start : 128;
        for(size_t i = 0; i < count; ++i) {
            double phase = 2 * PI * hz * (start + i) / tuner->sample_rate;
            block[i] = (int16_t)lround(amplitude * 32767 * (sin(phase) + .2 * sin(2 * phase)) / 1.2);
        }
        tuner_process(tuner, block, count);
    }
}

int main(void)
{
    MidiQueue queue = {0};
    Tuner tuner;
    tuner_init(&tuner, 48000, &queue);
    CHECK(tuner.enabled && tuner.note == -1);
    feed(&tuner, 440, .22, .5);
    CHECK(tuner.note == 69);
    CHECK(fabs(tuner.frequency - 440) < 2);
    CHECK(fabs(tuner.cents) < 8);
    CHECK(tuner.confidence > .8);
    char name[8];
    CHECK(strcmp(tuner_note_name(tuner.note, name, sizeof(name)), "A4") == 0);
    MidiEvent events[8];
    CHECK(midi_queue_drain(&queue, events, 8) == 1);
    CHECK(events[0].status == 0x90 && events[0].data1 == 69 && events[0].data2 > 0);
    feed(&tuner, 440, .15, .5);
    CHECK(midi_queue_drain(&queue, events, 8) == 0);
    feed(&tuner, 82.4069, .25, .5);
    CHECK(tuner.note == 40);
    CHECK(fabs(tuner.frequency - 82.4069) < 1);
    CHECK(midi_queue_drain(&queue, events, 8) == 2);
    CHECK(events[0].status == 0x80 && events[0].data1 == 69);
    CHECK(events[1].status == 0x90 && events[1].data1 == 40);
    feed(&tuner, 0, .15, 0);
    CHECK(tuner.note == -1);
    CHECK(midi_queue_drain(&queue, events, 8) == 1);
    CHECK(events[0].status == 0x80 && events[0].data1 == 40);
    feed(&tuner, 440, .2, .5);
    CHECK(tuner.note == 69);
    tuner_set_enabled(&tuner, false);
    CHECK(tuner.note == -1);
    CHECK(midi_queue_drain(&queue, events, 8) == 2);
    CHECK(events[0].status == 0x90 && events[1].status == 0x80);
    feed(&tuner, 440, .2, .5);
    CHECK(tuner.note == -1 && queue.count == 0);

    CHECK(!midi_queue_push(&queue, (MidiEvent){0, 0x70, 1, 1}));
    for(int i = 0; i < MIDI_QUEUE_CAPACITY + 3; ++i)
        CHECK(midi_queue_push(&queue, (MidiEvent){(uint64_t)i, 0x90, 60, 100}));
    CHECK(queue.count == MIDI_QUEUE_CAPACITY && queue.dropped == 3);
    MidiEvent all[MIDI_QUEUE_CAPACITY];
    CHECK(midi_queue_drain(&queue, all, MIDI_QUEUE_CAPACITY) == MIDI_QUEUE_CAPACITY);
    CHECK(all[0].frame == 3 && all[MIDI_QUEUE_CAPACITY - 1].frame == MIDI_QUEUE_CAPACITY + 2);

    for(int rate_index = 0; rate_index < 2; ++rate_index) {
        int rate = rate_index == 0 ? 44100 : 96000;
        MidiQueue other_queue = {0};
        Tuner other;
        tuner_init(&other, rate, &other_queue);
        feed(&other, 445, .25, .45);
        CHECK(other.note == 69);
        CHECK(other.cents > 12 && other.cents < 28);
        CHECK(midi_queue_drain(&other_queue, events, 8) == 1);
        CHECK(events[0].data1 == 69);
    }
    puts("tuner and MIDI API OK");
    return 0;
}
