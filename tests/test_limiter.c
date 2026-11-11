#include "pedal.h"

#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#define CHECK(condition) do { if(!(condition)) { \
    fprintf(stderr, "check failed: %s at line %d\n", #condition, __LINE__); abort(); \
} } while(0)

static void check_rate(int rate)
{
    Engine *engine = malloc(sizeof(*engine));
    CHECK(engine && engine_init(engine, rate, 128, 1));
    Pedal *limiter = engine_find(engine, "limiter");
    CHECK(limiter && limiter->ceiling == -1 && limiter->release == 80);
    CHECK(!engine_config(engine, limiter, "ceiling", 1));
    CHECK(!engine_config(engine, limiter, "ceiling", -37));
    CHECK(!engine_config(engine, limiter, "release", 4));
    CHECK(!engine_config(engine, limiter, "release", 1001));
    CHECK(!engine_config(engine, limiter, "release", NAN));
    CHECK(!engine_config(engine, limiter, "drive", 20));
    CHECK(engine_config(engine, limiter, "ceiling", -12));
    CHECK(engine_set_board(engine, (size_t[]){LIMITER}, 1));
    int16_t input[128] = {0}, output[128];
    for(int i = 0; i < rate / 128 + 1; ++i) engine_process(engine, input, output, 128);

    // A quiet impulse stays at the same sample: there is no lookahead delay.
    input[17] = 1000;
    engine_process(engine, input, output, 128);
    for(int i = 0; i < 128; ++i) CHECK(abs(output[i] - input[i]) <= 1);
    // Full-scale peaks of either polarity are caught on their first sample.
    for(int i = 0; i < 128; ++i) input[i] = i % 2 ? -32768 : 32767;
    engine_process(engine, input, output, 128);
    int ceiling = (int)ceil(32767 * pow(10, -12.0 / 20));
    for(int i = 0; i < 128; ++i) {
        CHECK(abs(output[i]) <= ceiling);
        CHECK(abs(output[i]) >= ceiling - 2);
    }
    // Quiet material recovers gradually, without makeup gain or a noise boost.
    for(int i = 0; i < 128; ++i) input[i] = 1000;
    engine_process(engine, input, output, 128);
    CHECK(output[0] >= 250 && output[0] < 300);
    int previous = output[0];
    for(int block = 0; block < rate / 128; ++block) {
        engine_process(engine, input, output, 128);
        CHECK(output[0] >= previous && output[0] <= 1000);
        previous = output[0];
    }
    CHECK(output[127] >= 998);
    CHECK(engine_set_bypass(engine, limiter, true));
    for(int block = 0; block < rate / 128 + 1; ++block) engine_process(engine, input, output, 128);
    for(int i = 0; i < 128; ++i) CHECK(output[i] == input[i]);
    engine_free(engine);
    free(engine);
}

int main(void)
{
    check_rate(8000);
    check_rate(48000);
    check_rate(192000);
    puts("limiter ceiling, polarity, release, latency and bypass OK");
    return 0;
}
