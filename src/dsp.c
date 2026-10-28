#include "pedal.h"

#include <math.h>
#include <stdlib.h>
#include <string.h>

#define PI 3.14159265358979323846

static int16_t pcm16(double value)
{
    long rounded = lrint(value);
    if(rounded > 32767) rounded = 32767;
    if(rounded < -32768) rounded = -32768;
    return (int16_t)rounded;
}

static void defaults(Pedal *pedal, PedalKind kind, int rate)
{
    static const char *ids[] = {"overdrive", "fuzz", "delay", "tremolo", "chorus"};
    static const char *names[] = {"Overdrive", "Fuzz", "Delay", "Tremolo", "Chorus"};
    memset(pedal, 0, sizeof(*pedal));
    pedal->kind = kind;
    pedal->sample_rate = rate;
    strcpy(pedal->id, ids[kind]);
    strcpy(pedal->name, names[kind]);
    if(kind == OVERDRIVE || kind == FUZZ) {
        pedal->drive = kind == OVERDRIVE ? 20 : 15;
        pedal->tone = kind == OVERDRIVE ? 3000 : 2500;
        pedal->level = kind == OVERDRIVE ? .5 : .45;
        pedal->mix = 1;
        pedal->alpha = 1 - exp(-2 * PI * pedal->tone / rate);
    } else if(kind == DELAY) {
        pedal->time = 300;
        pedal->feedback = .35;
        pedal->mix = .35;
        pedal->ring_size = (size_t)rate * 2;
    } else if(kind == TREMOLO) {
        pedal->rate = 5;
        pedal->depth = .7;
    } else {
        pedal->rate = 1.2;
        pedal->depth = .5;
        pedal->mix = .5;
        pedal->ring_size = (size_t)lround(rate * .06);
    }
    if(pedal->ring_size) pedal->ring = calloc(pedal->ring_size, sizeof(float));
}

bool engine_init(Engine *engine, int rate, size_t block, double clean_level)
{
    if(rate < 8000 || rate > 192000 || block < 16 || block > MAX_BLOCK ||
       !isfinite(clean_level) || clean_level < 0 || clean_level > 1) return false;
    memset(engine, 0, sizeof(*engine));
    engine->rate = rate;
    engine->block = block;
    engine->clean_level = clean_level;
    engine->amount = engine->wet = engine->target = 1;
    engine->enabled = true;
    engine->fade_samples = (size_t)rate / 100;
    engine->pedal_count = 5;
    for(size_t i = 0; i < 5; ++i) {
        defaults(&engine->pedals[i], (PedalKind)i, rate);
        if(engine->pedals[i].ring_size && !engine->pedals[i].ring) {
            engine_free(engine);
            return false;
        }
    }
    engine->active[0] = 0;
    engine->active_count = 1;
    tuner_init(&engine->tuner, rate, &engine->midi);
    return true;
}

void pedal_free(Pedal *pedal)
{
    if(pedal->instance) {
        lilv_instance_deactivate(pedal->instance);
        lilv_instance_free(pedal->instance);
    }
    free(pedal->ring);
    pedal->instance = NULL;
    pedal->ring = NULL;
}

void engine_free(Engine *engine)
{
    for(size_t i = 0; i < engine->previous_count; ++i) pedal_free(&engine->previous[i]);
    for(size_t i = 0; i < engine->pedal_count; ++i) pedal_free(&engine->pedals[i]);
    if(engine->world) lilv_world_free(engine->world);
    engine->world = NULL;
}

Pedal *engine_find(Engine *engine, const char *id)
{
    for(size_t i = 0; i < engine->pedal_count; ++i)
        if(strcmp(engine->pedals[i].id, id) == 0) return &engine->pedals[i];
    return NULL;
}

bool pedal_clone(Pedal *destination, const Pedal *source)
{
    *destination = *source;
    destination->ring = NULL;
    destination->instance = NULL;
    if(source->ring) {
        destination->ring = malloc(source->ring_size * sizeof(float));
        if(!destination->ring) return false;
        memcpy(destination->ring, source->ring, source->ring_size * sizeof(float));
    }
    if(source->instance && !lv2_clone(destination, source)) {
        pedal_free(destination);
        return false;
    }
    return true;
}

static bool snapshot(Engine *engine)
{
    for(size_t i = 0; i < engine->previous_count; ++i) pedal_free(&engine->previous[i]);
    engine->previous_count = 0;
    engine->transition = false;
    if(!engine->enabled && engine->wet == 0) return true;
    for(size_t i = 0; i < engine->active_count; ++i) {
        if(!pedal_clone(&engine->previous[i], &engine->pedals[engine->active[i]])) {
            for(size_t j = 0; j < i; ++j) pedal_free(&engine->previous[j]);
            return false;
        }
        engine->previous_count++;
    }
    engine->fade_position = 0;
    engine->transition = true;
    return true;
}

bool engine_set_board(Engine *engine, const size_t *indices, size_t count)
{
    if(count > MAX_ACTIVE) return false;
    for(size_t i = 0; i < count; ++i) {
        if(indices[i] >= engine->pedal_count) return false;
        for(size_t j = 0; j < i; ++j) if(indices[i] == indices[j]) return false;
    }
    if(count == engine->active_count &&
       (count == 0 || memcmp(indices, engine->active, count * sizeof(*indices)) == 0)) {
        return true;
    }
    if(!snapshot(engine)) return false;
    if(count) memcpy(engine->active, indices, count * sizeof(*indices));
    engine->active_count = count;
    return true;
}

static bool builtin_parameter(Pedal *pedal, const char *name, double value, int rate, double **field)
{
    double minimum = 0, maximum = 1;
    if(strcmp(name, "drive") == 0 && (pedal->kind == OVERDRIVE || pedal->kind == FUZZ)) {
        *field = &pedal->drive; minimum = 1; maximum = 100;
    } else if(strcmp(name, "tone") == 0 && (pedal->kind == OVERDRIVE || pedal->kind == FUZZ)) {
        *field = &pedal->tone; minimum = 100; maximum = rate / 2.0 - .000001;
    } else if(strcmp(name, "level") == 0 && (pedal->kind == OVERDRIVE || pedal->kind == FUZZ)) {
        *field = &pedal->level;
    } else if(strcmp(name, "mix") == 0 && (pedal->kind == OVERDRIVE || pedal->kind == DELAY || pedal->kind == CHORUS)) {
        *field = &pedal->mix;
    } else if(strcmp(name, "time") == 0 && pedal->kind == DELAY) {
        *field = &pedal->time; minimum = 20; maximum = 1500;
    } else if(strcmp(name, "feedback") == 0 && pedal->kind == DELAY) {
        *field = &pedal->feedback; maximum = .9;
    } else if(strcmp(name, "rate") == 0 && (pedal->kind == TREMOLO || pedal->kind == CHORUS)) {
        *field = &pedal->rate; minimum = .1; maximum = pedal->kind == TREMOLO ? 20 : 5;
    } else if(strcmp(name, "depth") == 0 && (pedal->kind == TREMOLO || pedal->kind == CHORUS)) {
        *field = &pedal->depth;
    } else return false;
    return isfinite(value) && value >= minimum && value <= maximum;
}

bool engine_config(Engine *engine, Pedal *pedal, const char *name, double value)
{
    if(!pedal || !isfinite(value)) return false;
    double *field = NULL;
    ControlPort *port = NULL;
    if(pedal->kind == LV2) {
        for(size_t i = 0; i < pedal->control_count; ++i)
            if(pedal->controls[i].input && strcmp(pedal->controls[i].symbol, name) == 0) port = &pedal->controls[i];
        if(!port || (port->has_minimum && value < port->minimum) ||
           (port->has_maximum && value > port->maximum)) return false;
    } else if(!builtin_parameter(pedal, name, value, engine->rate, &field)) return false;
    bool active = false;
    for(size_t i = 0; i < engine->active_count; ++i)
        if(pedal == &engine->pedals[engine->active[i]]) active = true;
    if(active && engine->wet > 0 && !snapshot(engine)) return false;
    if(port) port->value = (float)value;
    else *field = value;
    if(field && strcmp(name, "tone") == 0) pedal->alpha = 1 - exp(-2 * PI * value / engine->rate);
    return true;
}

static void process_builtin(Engine *engine, Pedal *pedal, const int16_t *input, int16_t *output, size_t count)
{
    const size_t size = pedal->ring_size;
    const double normalization = pedal->kind == OVERDRIVE ? tanh(pedal->drive) : 1;
    size_t delay_samples = 0;
    if(pedal->kind == DELAY) {
        delay_samples = (size_t)lround(pedal->time * engine->rate / 1000);
        if(delay_samples < 1) delay_samples = 1;
    }
    for(size_t i = 0; i < count; ++i) {
        float dry = (float)input[i] / 32768.0f;
        double result = dry;
        switch(pedal->kind) {
        case OVERDRIVE: {
            float distorted = tanhf(dry * (float)pedal->drive) / (float)normalization;
            pedal->filter += pedal->alpha * ((double)distorted - pedal->filter);
            result = ((1 - pedal->mix) * dry + pedal->mix * pedal->filter) * pedal->level;
            break;
        }
        case FUZZ: {
            float clipped = fminf(.35f, fmaxf(-.35f, dry * (float)pedal->drive)) / .35f;
            pedal->filter += pedal->alpha * ((double)clipped - pedal->filter);
            result = pedal->filter * pedal->level;
            break;
        }
        case DELAY: {
            float wet = pedal->ring[(pedal->position + size - delay_samples) % size];
            result = dry * (1 - pedal->mix) + wet * pedal->mix;
            pedal->ring[pedal->position] = (float)(dry + wet * pedal->feedback);
            pedal->position = (pedal->position + 1) % size;
            break;
        }
        case TREMOLO: {
            double gain = 1 - pedal->depth * (1 - sin(2 * PI * pedal->phase)) / 2;
            result = (double)input[i] * gain / 32767.0;
            pedal->phase = fmod(pedal->phase + pedal->rate / engine->rate, 1);
            break;
        }
        case CHORUS: {
            double delay = (12 + 8 * pedal->depth * sin(2 * PI * pedal->phase)) * engine->rate / 1000;
            double position = (double)pedal->position - delay;
            long low = (long)floor(position);
            double fraction = position - low;
            size_t a = (size_t)((low % (long)size + (long)size) % (long)size);
            size_t b = (a + 1) % size;
            double wet = pedal->ring[a] * (1 - fraction) + pedal->ring[b] * fraction;
            result = dry * (1 - pedal->mix) + wet * pedal->mix;
            pedal->ring[pedal->position] = dry;
            pedal->position = (pedal->position + 1) % size;
            pedal->phase = fmod(pedal->phase + pedal->rate / engine->rate, 1);
            break;
        }
        case LV2: break;
        }
        output[i] = pcm16(result * 32767);
    }
}

static void process_chain(Engine *engine, Pedal *pedals, const size_t *indices, size_t count,
                          const int16_t *input, int16_t *output, size_t frames, bool previous)
{
    if(!count) {
        for(size_t i = 0; i < frames; ++i) output[i] = pcm16(input[i] * engine->clean_level);
        return;
    }
    const int16_t *source = input;
    for(size_t i = 0; i < count; ++i) {
        int16_t *destination = i == count - 1 ? output : (i & 1 ? engine->scratch_b : engine->scratch_a);
        Pedal *pedal = previous ? &pedals[i] : &pedals[indices[i]];
        if(pedal->kind == LV2) lv2_process(engine, pedal, source, destination, frames);
        else process_builtin(engine, pedal, source, destination, frames);
        source = destination;
    }
}

void engine_process(Engine *engine, const int16_t *input, int16_t *output, size_t count)
{
    if(count > MAX_BLOCK) return;
    tuner_process(&engine->tuner, input, count);
    process_chain(engine, engine->pedals, engine->active, engine->active_count,
                  input, output, count, false);
    if(engine->transition)
        process_chain(engine, engine->previous, NULL, engine->previous_count,
                      input, engine->old, count, true);
    for(size_t i = 0; i < count; ++i) {
        double dirty = output[i];
        if(engine->transition) {
            double progress = (double)(engine->fade_position + i + 1) / engine->fade_samples;
            if(progress > 1) progress = 1;
            dirty = engine->old[i] * (1 - progress) + dirty * progress;
        }
        double clean = input[i] * engine->clean_level;
        if(engine->wet < engine->target) engine->wet = fmin(engine->target, engine->wet + 1.0 / engine->fade_samples);
        else if(engine->wet > engine->target) engine->wet = fmax(engine->target, engine->wet - 1.0 / engine->fade_samples);
        output[i] = pcm16(clean * (1 - engine->wet) + dirty * engine->wet);
    }
    if(engine->transition) {
        engine->fade_position += count;
        if(engine->fade_position >= engine->fade_samples) {
            for(size_t i = 0; i < engine->previous_count; ++i) pedal_free(&engine->previous[i]);
            engine->previous_count = 0;
            engine->transition = false;
        }
    }
}
