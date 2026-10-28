#ifndef PEDAL_TUNER_H
#define PEDAL_TUNER_H

#include "midi.h"
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#define TUNER_WINDOW 768

typedef struct {
    int sample_rate, decimation, decimation_count;
    double filtered, decimation_sum;
    float samples[TUNER_WINDOW];
    size_t write, filled, since_analysis;
    uint64_t frame;
    bool enabled;
    int note, candidate, candidate_count, silence_count, midi_note;
    double frequency, cents, confidence;
    MidiQueue *midi;
} Tuner;

void tuner_init(Tuner *tuner, int sample_rate, MidiQueue *midi);
void tuner_set_enabled(Tuner *tuner, bool enabled);
void tuner_process(Tuner *tuner, const int16_t *samples, size_t count);
const char *tuner_note_name(int note, char *buffer, size_t size);

#endif
