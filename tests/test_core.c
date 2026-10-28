#include "pedal.h"

#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#undef assert
#define assert(condition) do { if(!(condition)) { \
    fprintf(stderr, "check failed: %s at line %d\n", #condition, __LINE__); abort(); \
} } while(0)

int main(void)
{
    Engine *engine = malloc(sizeof(*engine));
    assert(engine);
    assert(!engine_init(engine, 7999, 128, 1));
    assert(!engine_init(engine, 48000, MAX_BLOCK + 1, 1));
    assert(!engine_init(engine, 48000, 128, 1.1));
    assert(engine_init(engine, 48000, 128, 1));
    assert(engine->pedal_count == 5);
    const char *ids[] = {"overdrive", "fuzz", "delay", "tremolo", "chorus"};
    for(size_t i = 0; i < 5; ++i) assert(engine_find(engine, ids[i]) == &engine->pedals[i]);
    assert(engine_find(engine, "missing") == NULL);
    int16_t input[128] = {0}, output[128];
    input[0] = 10000;
    engine_process(engine, input, output, 128);
    assert(output[0] > 0 && output[0] < 10000);
    size_t board[] = {2};
    assert(engine_set_board(engine, board, 1));
    assert(engine->transition);
    assert(engine->active_count == 1 && engine->active[0] == 2);
    assert(!engine_set_board(engine, (size_t[]){5}, 1));
    assert(engine->active_count == 1 && engine->active[0] == 2);
    for(int i = 0; i < 5; ++i) engine_process(engine, input, output, 128);
    assert(!engine->transition && engine->previous_count == 0);
    assert(engine_config(engine, &engine->pedals[2], "mix", 1));
    assert(!engine_config(engine, &engine->pedals[2], "feedback", 2));
    assert(!engine_config(engine, &engine->pedals[2], "feedback", NAN));
    assert(!engine_config(engine, &engine->pedals[2], "unknown", .5));
    assert(engine->pedals[2].feedback == .35);
    for(int i = 0; i < 5; ++i) engine_process(engine, input, output, 128);
    assert(output[0] == 0);
    assert(!engine_set_board(engine, (size_t[]){0, 0}, 2));
    assert(engine->active_count == 1 && engine->active[0] == 2);
    assert(engine_set_board(engine, NULL, 0));
    for(int i = 0; i < 5; ++i) engine_process(engine, input, output, 128);
    assert(output[0] == 10000);
    for(size_t pedal = 0; pedal < 5; ++pedal) {
        size_t selected[] = {pedal};
        assert(engine_set_board(engine, selected, 1));
        engine->enabled = true;
        engine->target = 1;
        for(int i = 0; i < 6; ++i) engine_process(engine, input, output, 128);
        assert(output[0] != input[0]);
    }
    engine->enabled = false;
    engine->target = 0;
    for(int i = 0; i < 5; ++i) engine_process(engine, input, output, 128);
    assert(output[0] == 10000);
    const char *uri = "https://example.org/c-pedal/test-gain";
    char error[256] = "";
    assert(!lv2_load(engine, "https://example.org/c-pedal/missing", error, sizeof(error)));
    assert(lv2_load(engine, uri, error, sizeof(error)));
    assert(engine->pedals[5].instance != NULL && engine->pedal_count == 6);
    assert(lv2_load(engine, uri, error, sizeof(error)) && engine->pedal_count == 6);
    size_t imported[] = {5};
    engine->enabled = true;
    engine->target = 1;
    assert(engine_set_board(engine, imported, 1));
    for(int i = 0; i < 5; ++i) engine_process(engine, input, output, 128);
    assert(output[0] > 4500 && output[0] < 5500);
    assert(!engine_config(engine, &engine->pedals[5], "gain", 2));
    assert(engine_config(engine, &engine->pedals[5], "gain", .25));
    for(int i = 0; i < 5; ++i) engine_process(engine, input, output, 128);
    assert(output[0] > 2000 && output[0] < 3000);
    size_t leave_plugin[] = {2};
    assert(engine_set_board(engine, leave_plugin, 1));
    for(int i = 0; i < 5; ++i) engine_process(engine, input, output, 128);
    engine_free(engine);
    free(engine);
    puts("pedal core OK");
    return 0;
}
