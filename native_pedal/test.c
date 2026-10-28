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
    assert(engine && engine_init(engine, 48000, 128, 1));
    int16_t input[128] = {0}, output[128];
    input[0] = 10000;
    engine_process(engine, input, output, 128);
    assert(output[0] > 0 && output[0] < 10000);
    size_t board[] = {2};
    assert(engine_set_board(engine, board, 1));
    assert(engine->active_count == 1 && engine->active[0] == 2);
    for(int i = 0; i < 5; ++i) engine_process(engine, input, output, 128);
    assert(engine_config(engine, &engine->pedals[2], "mix", 1));
    assert(!engine_config(engine, &engine->pedals[2], "feedback", 2));
    for(int i = 0; i < 5; ++i) engine_process(engine, input, output, 128);
    assert(output[0] == 0);
    assert(!engine_set_board(engine, (size_t[]){0, 0}, 2));
    assert(engine_set_board(engine, NULL, 0));
    for(int i = 0; i < 5; ++i) engine_process(engine, input, output, 128);
    assert(output[0] == 10000);
    engine->enabled = false;
    engine->target = 0;
    for(int i = 0; i < 5; ++i) engine_process(engine, input, output, 128);
    assert(output[0] == 10000);
    const char *uri = "http://guitarix.sourceforge.net/plugins/gx_aclipper_#_aclipper_";
    if(lv2_world_init(engine)) {
        LilvNode *node = lilv_new_uri(engine->world, uri);
        const LilvPlugin *plugin = lilv_plugins_get_by_uri(lilv_world_get_all_plugins(engine->world), node);
        lilv_node_free(node);
        if(plugin && lv2_compatible(engine, plugin)) {
            char error[256] = "";
            assert(lv2_load(engine, uri, error, sizeof(error)));
            size_t imported[] = {5};
            assert(engine_set_board(engine, imported, 1));
            for(int i = 0; i < 5; ++i) engine_process(engine, input, output, 128);
            assert(engine->pedals[5].instance != NULL);
            size_t leave_plugin[] = {2};
            assert(engine_set_board(engine, leave_plugin, 1));
            for(int i = 0; i < 5; ++i) engine_process(engine, input, output, 128);
        }
    }
    engine_free(engine);
    free(engine);
    puts("pedal core OK");
    return 0;
}
