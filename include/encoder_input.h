#ifndef PEDAL_ENCODER_INPUT_H
#define PEDAL_ENCODER_INPUT_H

#include <stdbool.h>
#include <stdint.h>

#define ENCODER_BUTTON_DEBOUNCE_NS 30000000ULL

typedef struct {
    unsigned ab, edges_per_step;
    int partial;
    bool raw_pressed, pressed;
    uint64_t button_changed_ns;
} EncoderInput;

typedef struct { int steps; bool press; } EncoderAction;

void encoder_input_init(EncoderInput *input, unsigned ab, bool button_low,
                        unsigned edges_per_step, uint64_t now_ns);
EncoderAction encoder_input_sample(EncoderInput *input, unsigned ab, bool button_low, uint64_t now_ns);

#endif
