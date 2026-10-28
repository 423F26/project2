#ifndef PEDAL_H
#define PEDAL_H

#include <lilv/lilv.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#define MAX_PEDALS 37
#define MAX_ACTIVE 32
#define MAX_PORTS 128
#define MAX_BLOCK 8192

typedef enum { OVERDRIVE, FUZZ, DELAY, TREMOLO, CHORUS, LV2 } PedalKind;

typedef struct {
    uint32_t index;
    char symbol[96];
    float value;
    float minimum;
    float maximum;
    bool has_minimum;
    bool has_maximum;
    bool input;
} ControlPort;

typedef struct {
    PedalKind kind;
    int sample_rate;
    char id[32];
    char name[256];
    char uri[2048];
    double drive, tone, mix, level, time, feedback, rate, depth;
    double alpha, filter, phase;
    float *ring;
    size_t ring_size, position;
    LilvInstance *instance;
    uint32_t audio_in, audio_out;
    ControlPort controls[MAX_PORTS];
    size_t control_count;
    const LilvPlugin *plugin;
} Pedal;

typedef struct {
    int rate;
    size_t block;
    double clean_level, amount, wet, target;
    bool enabled;
    Pedal pedals[MAX_PEDALS];
    size_t pedal_count;
    size_t active[MAX_ACTIVE], active_count;
    size_t slots[MAX_ACTIVE], slot_count;
    Pedal previous[MAX_ACTIVE];
    size_t previous_count;
    bool transition;
    size_t fade_position, fade_samples;
    LilvWorld *world;
    int16_t scratch_a[MAX_BLOCK], scratch_b[MAX_BLOCK], old[MAX_BLOCK];
    float lv2_in[MAX_BLOCK], lv2_out[MAX_BLOCK];
} Engine;

bool engine_init(Engine *engine, int rate, size_t block, double clean_level);
void engine_free(Engine *engine);
Pedal *engine_find(Engine *engine, const char *id);
bool engine_set_board(Engine *engine, const size_t *indices, size_t count);
bool engine_config(Engine *engine, Pedal *pedal, const char *name, double value);
void engine_process(Engine *engine, const int16_t *input, int16_t *output, size_t count);
bool pedal_clone(Pedal *destination, const Pedal *source);
void pedal_free(Pedal *pedal);

bool lv2_world_init(Engine *engine);
bool lv2_compatible(Engine *engine, const LilvPlugin *plugin);
bool lv2_load(Engine *engine, const char *uri, char *error, size_t error_size);
bool lv2_clone(Pedal *destination, const Pedal *source);
void lv2_process(Engine *engine, Pedal *pedal, const int16_t *input, int16_t *output, size_t count);

#endif
