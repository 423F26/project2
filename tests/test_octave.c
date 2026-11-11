#include "pedal.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define CHECK(condition) do { if(!(condition)) { \
    fprintf(stderr, "check failed: %s at line %d\n", #condition, __LINE__); abort(); \
} } while(0)

static double shifted_frequency(double ratio)
{
    Engine *engine = malloc(sizeof(*engine));
    CHECK(engine && engine_init(engine, 48000, 128, 1));
    char error[256] = "";
    CHECK(lv2_load(engine, OCTAVE_URI, error, sizeof(error)));
    Pedal *octave = engine_find(engine, "octave");
    CHECK(octave && strcmp(octave->name, "Octave") == 0);
    CHECK(fabs(octave->mix - .65) < .00001);
    CHECK(engine_config(engine, octave, "pitch", ratio));
    CHECK(engine_config(engine, octave, "mix", 1));
    CHECK(!engine_config(engine, octave, "mix", 1.1));
    CHECK(!engine_config(engine, octave, "pitch", 5));
    size_t board[] = {(size_t)(octave - engine->pedals)};
    CHECK(engine_set_board(engine, board, 1));
    int16_t input[128], output[128], previous = 0;
    unsigned crossings = 0;
    double energy = 0;
    for(size_t position = 0; position < 96000; position += 128) {
        for(size_t i = 0; i < 128; ++i)
            input[i] = (int16_t)lrint(8000 * sin(2 * 3.141592653589793 * 220 * (position+i) / 48000));
        engine_process(engine, input, output, 128);
        if(position >= 48000) {
            for(size_t i = 0; i < 128; ++i) {
                if(previous <= 0 && output[i] > 0) crossings++;
                previous = output[i];
                energy += (double)output[i] * output[i];
            }
        }
    }
    CHECK(energy / 48000 > 100000);
    CHECK(engine_config(engine, octave, "mix", 0));
    for(int i = 0; i < 6; ++i) engine_process(engine, input, output, 128);
    CHECK(memcmp(input, output, sizeof(input)) == 0);
    CHECK(engine_set_bypass(engine, octave, true));
    for(int i = 0; i < 6; ++i) engine_process(engine, input, output, 128);
    CHECK(memcmp(input, output, sizeof(input)) == 0);
    double latency = 0;
    for(size_t i = 0; i < octave->control_count; ++i)
        if(strcmp(octave->controls[i].symbol, "latency") == 0) latency = octave->controls[i].value;
    printf("Octave ratio %.1f: %u positive crossings/second; reported latency %.1f ms\n",
           ratio, crossings, latency / 48);
    engine_free(engine);
    free(engine);
    return crossings;
}

int main(void)
{
    Engine *probe = malloc(sizeof(*probe));
    CHECK(probe && engine_init(probe, 48000, 128, 1));
    char error[256] = "";
    bool installed = lv2_load(probe, OCTAVE_URI, error, sizeof(error));
    engine_free(probe);
    free(probe);
    if(!installed) {
        fprintf(stderr, "Octave plugin unavailable: %s\n", error);
        return strstr(error, "not installed") ? 77 : 1;
    }
    double down = shifted_frequency(.5), up = shifted_frequency(2);
    CHECK(fabs(down - 110) < 3);
    CHECK(fabs(up - 440) < 4);
    puts("Octave up/down, dry blend, bypass and input validation OK");
    return 0;
}
