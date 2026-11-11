#include "encoder_input.h"
#include "pedal.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define CHECK(condition) do { if(!(condition)) { \
    fprintf(stderr, "check failed: %s at line %d\n", #condition, __LINE__); abort(); \
} } while(0)

static void input_tests(void)
{
    EncoderInput input;
    encoder_input_init(&input, 3, false, 4, 0);
    unsigned cw[] = {1, 3, 1, 0, 2, 3}; // Contact bounce cancels rather than counting twice.
    int steps = 0;
    for(size_t i = 0; i < sizeof(cw)/sizeof(cw[0]); ++i)
        steps += encoder_input_sample(&input, cw[i], false, i * 1000000).steps;
    CHECK(steps == 1);
    unsigned ccw[] = {2, 0, 1, 3};
    for(size_t i = 0; i < 4; ++i) steps += encoder_input_sample(&input, ccw[i], false, 10000000 + i * 1000000).steps;
    CHECK(steps == 0);
    CHECK(encoder_input_sample(&input, 1, false, 20000000).steps == 0);
    CHECK(encoder_input_sample(&input, 2, false, 21000000).steps == 0); // Invalid two-bit jump resets partial motion.
    CHECK(encoder_input_sample(&input, 3, false, 22000000).steps == 0);
    encoder_input_init(&input, 3, false, 2, 0);
    steps = 0;
    for(size_t i = 0; i < 4; ++i) steps += encoder_input_sample(&input, ccw[i], false, i * 1000000).steps;
    CHECK(steps == -2);

    encoder_input_init(&input, 3, false, 4, 0);
    CHECK(!encoder_input_sample(&input, 3, true, 1000000).press);
    CHECK(!encoder_input_sample(&input, 3, false, 4000000).press);
    CHECK(!encoder_input_sample(&input, 3, true, 7000000).press);
    CHECK(!encoder_input_sample(&input, 3, true, 36000000).press);
    CHECK(encoder_input_sample(&input, 3, true, 37000000).press);
    CHECK(!encoder_input_sample(&input, 3, true, 1000000000).press); // Holding never repeats.
    CHECK(!encoder_input_sample(&input, 3, false, 1001000000).press);
    CHECK(!encoder_input_sample(&input, 3, false, 1040000000).press);
    CHECK(!encoder_input_sample(&input, 3, true, 1100000000).press);
    // A whole valid press buffered between polls is still one press on release.
    CHECK(encoder_input_sample(&input, 3, false, 1150000000).press);
    encoder_input_init(&input, 3, true, 4, 0);
    CHECK(!encoder_input_sample(&input, 3, true, 1000000000).press); // Held at startup is not a new press.
}

static void binding_tests(void)
{
    Engine *engine = malloc(sizeof(*engine));
    CHECK(engine && engine_init(engine, 48000, 128, 1));
    CHECK(!engine_encoder_turn(engine, 1) && !engine_encoder_press(engine));
    CHECK(!engine_encoder_assign(engine, "unknown", "drive"));
    CHECK(!engine_encoder_assign(engine, "fuzz", "unknown"));
    engine->wet = 0;
    const char *parameters[][5] = {
        {"overdrive", "drive", "tone", "mix", "level"}, {"fuzz", "drive", "tone", "level", NULL},
        {"delay", "time", "feedback", "mix", NULL}, {"tremolo", "rate", "depth", NULL, NULL},
        {"chorus", "rate", "depth", "mix", NULL}, {"limiter", "ceiling", "release", NULL, NULL}
    };
    for(size_t i = 0; i < BUILTIN_COUNT; ++i) {
        Pedal *pedal = engine_find(engine, parameters[i][0]);
        for(size_t j = 1; j < 5 && parameters[i][j]; ++j) {
            ParameterInfo initial, current;
            CHECK(engine_parameter_info(engine, pedal, parameters[i][j], &initial));
            CHECK(initial.step > 0 && initial.has_minimum && initial.has_maximum);
            CHECK(engine_encoder_assign(engine, pedal->id, parameters[i][j]));
            CHECK(engine_encoder_turn(engine, 1000));
            CHECK(engine_parameter_info(engine, pedal, parameters[i][j], &current));
            CHECK(current.value <= current.maximum && current.value >= initial.value);
            CHECK(engine_encoder_turn(engine, -1000));
            CHECK(engine_parameter_info(engine, pedal, parameters[i][j], &current));
            CHECK(current.value >= current.minimum && current.value <= initial.value);
        }
    }
    CHECK(engine_encoder_assign(engine, "fuzz", "drive"));
    CHECK(engine_config(engine, engine_find(engine, "fuzz"), "drive", 40));
    CHECK(engine_encoder_turn(engine, 1));
    CHECK(engine_find(engine, "fuzz")->drive == 41); // Uses current value, including a touch edit.
    CHECK(engine_encoder_press(engine) && engine_find(engine, "fuzz")->bypassed);
    CHECK(!engine_find(engine, "overdrive")->bypassed && engine->enabled);
    CHECK(engine_encoder_press(engine) && !engine_find(engine, "fuzz")->bypassed);
    CHECK(!engine_encoder_assign(engine, "fuzz", "mix"));
    CHECK(strcmp(engine->encoder_pedal, "fuzz") == 0 && strcmp(engine->encoder_parameter, "drive") == 0);
    CHECK(!engine_encoder_turn(engine, 1001));

    char error[256];
    CHECK(lv2_load(engine, OCTAVE_URI, error, sizeof(error)));
    CHECK(engine_encoder_assign(engine, "octave", "pitch"));
    CHECK(engine_encoder_turn(engine, 1));
    ParameterInfo pitch;
    CHECK(engine_parameter_info(engine, engine_find(engine, "octave"), "pitch", &pitch) && pitch.value == 1);
    CHECK(engine_encoder_turn(engine, 1));
    CHECK(engine_parameter_info(engine, engine_find(engine, "octave"), "pitch", &pitch) && pitch.value == 2);
    CHECK(engine_encoder_turn(engine, -1000));
    CHECK(engine_parameter_info(engine, engine_find(engine, "octave"), "pitch", &pitch) && pitch.value == .5);
    CHECK(engine_encoder_assign(engine, "octave", "mix") && engine_encoder_turn(engine, 1));
    CHECK(!engine_encoder_assign(engine, "octave", "latency"));
    CHECK(lv2_load(engine, "https://example.org/c-pedal/test-gain", error, sizeof(error)));
    CHECK(engine_encoder_assign(engine, "lv2-1", "gain") && engine_encoder_turn(engine, 1));
    CHECK(engine_parameter_info(engine, engine_find(engine, "lv2-1"), "gain", &pitch));
    CHECK(fabs(pitch.value - .51) < .00001);
    CHECK(engine_encoder_assign(engine, "lv2-1", "mode") && engine_encoder_turn(engine, 1));
    CHECK(engine_parameter_info(engine, engine_find(engine, "lv2-1"), "mode", &pitch) && pitch.value == 1);
    CHECK(engine_encoder_turn(engine, 1));
    CHECK(engine_parameter_info(engine, engine_find(engine, "lv2-1"), "mode", &pitch) && pitch.value == 2);
    CHECK(engine_encoder_turn(engine, -1000));
    CHECK(engine_parameter_info(engine, engine_find(engine, "lv2-1"), "mode", &pitch) && pitch.value == .5);
    CHECK(engine_encoder_assign(engine, "lv2-1", "switch") && engine_encoder_turn(engine, 10));
    CHECK(engine_parameter_info(engine, engine_find(engine, "lv2-1"), "switch", &pitch) && pitch.value == 1);
    CHECK(engine_encoder_turn(engine, -10));
    CHECK(engine_parameter_info(engine, engine_find(engine, "lv2-1"), "switch", &pitch) && pitch.value == 0);
    CHECK(engine_encoder_assign(engine, "lv2-1", "steps") && engine_encoder_turn(engine, 1));
    CHECK(engine_parameter_info(engine, engine_find(engine, "lv2-1"), "steps", &pitch) && pitch.value == 3);
    engine_free(engine); free(engine);
}

int main(void)
{
    input_tests(); binding_tests();
    puts("encoder bounce, direction, press debounce, assignments and parameter bounds OK");
    return 0;
}
