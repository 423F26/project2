#include "tuner.h"

#include <math.h>
#include <stdio.h>
#include <string.h>

#define PI 3.14159265358979323846
#define TUNER_MIN_HZ 65.0
#define TUNER_MAX_HZ 1200.0

static void emit(Tuner *tuner, uint8_t status, int note, int velocity)
{
    if(tuner->midi && note >= 0 && note <= 127)
        midi_queue_push(tuner->midi, (MidiEvent){tuner->frame, status, (uint8_t)note, (uint8_t)velocity});
}

static void clear_pitch(Tuner *tuner)
{
    tuner->note = -1;
    tuner->candidate = -1;
    tuner->candidate_count = 0;
    tuner->frequency = tuner->cents = tuner->confidence = 0;
    if(tuner->midi_note >= 0) emit(tuner, 0x80, tuner->midi_note, 0);
    tuner->midi_note = -1;
}

void tuner_init(Tuner *tuner, int sample_rate, MidiQueue *midi)
{
    memset(tuner, 0, sizeof(*tuner));
    tuner->sample_rate = sample_rate;
    tuner->decimation = sample_rate / 12000;
    if(tuner->decimation < 1) tuner->decimation = 1;
    tuner->midi = midi;
    tuner->enabled = true;
    tuner->note = tuner->candidate = tuner->midi_note = -1;
}

void tuner_set_enabled(Tuner *tuner, bool enabled)
{
    if(!enabled && tuner->enabled) clear_pitch(tuner);
    tuner->enabled = enabled;
    if(!enabled) {
        tuner->filled = tuner->write = tuner->since_analysis = 0;
        tuner->decimation_count = 0;
        tuner->decimation_sum = tuner->filtered = 0;
    }
}

const char *tuner_note_name(int note, char *buffer, size_t size)
{
    static const char *names[] = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};
    if(note < 0 || note > 127 || size < 6) return NULL;
    snprintf(buffer, size, "%s%d", names[note % 12], note / 12 - 1);
    return buffer;
}

static void analyze(Tuner *tuner)
{
    const double rate = (double)tuner->sample_rate / tuner->decimation;
    int min_lag = (int)floor(rate / TUNER_MAX_HZ);
    int max_lag = (int)ceil(rate / TUNER_MIN_HZ);
    if(min_lag < 2) min_lag = 2;
    if(max_lag >= TUNER_WINDOW / 2) max_lag = TUNER_WINDOW / 2 - 1;
    const int span = TUNER_WINDOW - max_lag;
    float window[TUNER_WINDOW];
    for(size_t i = 0; i < TUNER_WINDOW; ++i)
        window[i] = tuner->samples[(tuner->write + i) % TUNER_WINDOW];

    double square = 0;
    for(int i = 0; i < TUNER_WINDOW; ++i) square += (double)window[i] * window[i];
    double rms = sqrt(square / TUNER_WINDOW);
    if(rms < .008) {
        if(++tuner->silence_count >= 2) clear_pitch(tuner);
        return;
    }
    tuner->silence_count = 0;

    double difference[TUNER_WINDOW / 2] = {0};
    double cumulative = 0, best = 1e9;
    int selected = -1;
    for(int lag = 1; lag <= max_lag; ++lag) {
        double sum = 0;
        for(int i = 0; i < span; ++i) {
            double delta = (double)window[i] - window[i + lag];
            sum += delta * delta;
        }
        cumulative += sum;
        difference[lag] = cumulative > 0 ? sum * lag / cumulative : 1;
        if(lag >= min_lag && difference[lag] < .18 && difference[lag] < best) {
            best = difference[lag];
            selected = lag;
        }
        if(selected > 0 && lag > selected + 2 && difference[lag] > best * 1.15) break;
    }
    if(selected < 0) {
        if(++tuner->silence_count >= 2) clear_pitch(tuner);
        return;
    }
    double lag = selected;
    if(selected > 1 && selected < max_lag) {
        double left = difference[selected - 1], center = difference[selected], right = difference[selected + 1];
        double denominator = left - 2 * center + right;
        if(fabs(denominator) > 1e-12) lag += fmax(-.5, fmin(.5, .5 * (left - right) / denominator));
    }
    double frequency = rate / lag;
    if(frequency < TUNER_MIN_HZ || frequency > TUNER_MAX_HZ) return;
    double midi = 69 + 12 * log2(frequency / 440.0);
    int note = (int)lround(midi);
    if(note < 0 || note > 127) return;
    if(tuner->candidate != note) { tuner->candidate = note; tuner->candidate_count = 1; }
    else if(tuner->candidate_count < 3) tuner->candidate_count++;
    if(tuner->candidate_count < 2) return;
    tuner->note = note;
    tuner->frequency = frequency;
    tuner->cents = 100 * (midi - note);
    tuner->confidence = fmax(0, fmin(1, 1 - best));
    if(tuner->midi_note != note) {
        if(tuner->midi_note >= 0) emit(tuner, 0x80, tuner->midi_note, 0);
        int velocity = (int)lround(rms * 300);
        if(velocity < 1) velocity = 1;
        if(velocity > 127) velocity = 127;
        emit(tuner, 0x90, note, velocity);
        tuner->midi_note = note;
    }
}

void tuner_process(Tuner *tuner, const int16_t *samples, size_t count)
{
    if(!tuner || !samples) return;
    double alpha = 1 - exp(-2 * PI * 2000 / tuner->sample_rate);
    for(size_t i = 0; i < count; ++i) {
        tuner->frame++;
        if(!tuner->enabled) continue;
        tuner->filtered += alpha * ((double)samples[i] / 32768 - tuner->filtered);
        tuner->decimation_sum += tuner->filtered;
        if(++tuner->decimation_count != tuner->decimation) continue;
        float value = (float)(tuner->decimation_sum / tuner->decimation);
        tuner->decimation_sum = 0;
        tuner->decimation_count = 0;
        tuner->samples[tuner->write] = value;
        tuner->write = (tuner->write + 1) % TUNER_WINDOW;
        if(tuner->filled < TUNER_WINDOW) tuner->filled++;
        if(tuner->filled == TUNER_WINDOW && ++tuner->since_analysis >= 256) {
            tuner->since_analysis = 0;
            analyze(tuner);
        }
    }
}
