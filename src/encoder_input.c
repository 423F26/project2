#include "encoder_input.h"

void encoder_input_init(EncoderInput *input, unsigned ab, bool button_low,
                        unsigned edges_per_step, uint64_t now_ns)
{
    *input = (EncoderInput){.ab = ab & 3, .edges_per_step = edges_per_step == 2 ? 2 : 4,
        .raw_pressed = button_low, .pressed = button_low, .button_changed_ns = now_ns};
}

EncoderAction encoder_input_sample(EncoderInput *input, unsigned ab, bool button_low, uint64_t now_ns)
{
    static const int transition[16] = {0, -1, 1, 0, 1, 0, 0, -1, -1, 0, 0, 1, 0, 1, -1, 0};
    EncoderAction action = {0};
    ab &= 3;
    if((input->ab ^ ab) == 3) input->partial = 0; // Lost/invalid edge: don't invent a turn.
    else input->partial += transition[input->ab * 4 + ab];
    input->ab = ab;
    if(input->partial >= (int)input->edges_per_step) { action.steps = 1; input->partial = 0; }
    else if(input->partial <= -(int)input->edges_per_step) { action.steps = -1; input->partial = 0; }
    if(input->pressed != input->raw_pressed && now_ns >= input->button_changed_ns &&
       now_ns - input->button_changed_ns >= ENCODER_BUTTON_DEBOUNCE_NS) {
        input->pressed = input->raw_pressed;
        action.press = input->pressed;
    }
    if(button_low != input->raw_pressed) {
        input->raw_pressed = button_low;
        input->button_changed_ns = now_ns;
    }
    return action;
}
