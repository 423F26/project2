#include "pedal.h"

#include <math.h>
#include <stdio.h>
#include <string.h>

#define CORE "http://lv2plug.in/ns/lv2core#"

bool lv2_world_init(Engine *engine)
{
    if(engine->world) return true;
    engine->world = lilv_world_new();
    if(!engine->world) return false;
    lilv_world_load_all(engine->world);
    return true;
}

bool lv2_compatible(Engine *engine, const LilvPlugin *plugin)
{
    LilvNodes *required = lilv_plugin_get_required_features(plugin);
    bool supported = !required || lilv_nodes_size(required) == 0;
    if(required) lilv_nodes_free(required);
    if(!supported) return false;
    uint32_t count = lilv_plugin_get_num_ports(plugin);
    if(count > MAX_PORTS) return false;
    const char *classes[] = {CORE "AudioPort", CORE "ControlPort", CORE "InputPort", CORE "OutputPort"};
    LilvNode *nodes[4];
    for(size_t i = 0; i < 4; ++i) nodes[i] = lilv_new_uri(engine->world, classes[i]);
    unsigned inputs = 0, outputs = 0;
    for(uint32_t i = 0; i < count && supported; ++i) {
        const LilvPort *port = lilv_plugin_get_port_by_index(plugin, i);
        bool audio = lilv_port_is_a(plugin, port, nodes[0]);
        bool control = lilv_port_is_a(plugin, port, nodes[1]);
        bool input = lilv_port_is_a(plugin, port, nodes[2]);
        bool output = lilv_port_is_a(plugin, port, nodes[3]);
        if(audio && input) inputs++;
        else if(audio && output) outputs++;
        else if(control && (input || output)) { }
        else supported = false;
    }
    for(size_t i = 0; i < 4; ++i) lilv_node_free(nodes[i]);
    return supported && inputs == 1 && outputs == 1;
}

static void connect_controls(Pedal *pedal)
{
    for(size_t i = 0; i < pedal->control_count; ++i)
        lilv_instance_connect_port(pedal->instance, pedal->controls[i].index,
                                   &pedal->controls[i].value);
}

bool lv2_clone(Pedal *destination, const Pedal *source)
{
    destination->instance = lilv_plugin_instantiate(source->plugin, source->sample_rate, NULL);
    if(!destination->instance) return false;
    connect_controls(destination);
    lilv_instance_activate(destination->instance);
    return true;
}

bool lv2_load(Engine *engine, const char *uri, char *error, size_t error_size)
{
    if(!uri || !*uri || strlen(uri) >= sizeof(engine->pedals[0].uri) ||
       strpbrk(uri, " \t\r\n")) {
        snprintf(error, error_size, "invalid LV2 URI");
        return false;
    }
    for(size_t i = 5; i < engine->pedal_count; ++i)
        if(strcmp(engine->pedals[i].uri, uri) == 0) return true;
    if(engine->pedal_count == MAX_PEDALS) {
        snprintf(error, error_size, "pedal library is full");
        return false;
    }
    if(!lv2_world_init(engine)) {
        snprintf(error, error_size, "could not initialize Lilv");
        return false;
    }
    LilvNode *node = lilv_new_uri(engine->world, uri);
    if(!node) {
        snprintf(error, error_size, "invalid LV2 URI");
        return false;
    }
    const LilvPlugin *plugin = lilv_plugins_get_by_uri(lilv_world_get_all_plugins(engine->world), node);
    lilv_node_free(node);
    if(!plugin) {
        snprintf(error, error_size, "LV2 plugin is not installed");
        return false;
    }
    if(!lv2_compatible(engine, plugin)) {
        snprintf(error, error_size, "LV2 plugin needs unsupported ports or features");
        return false;
    }
    Pedal *pedal = &engine->pedals[engine->pedal_count];
    memset(pedal, 0, sizeof(*pedal));
    pedal->kind = LV2;
    pedal->sample_rate = engine->rate;
    pedal->plugin = plugin;
    snprintf(pedal->id, sizeof(pedal->id), "lv2-%zu", engine->pedal_count - 4);
    snprintf(pedal->uri, sizeof(pedal->uri), "%s", uri);
    LilvNode *plugin_name = lilv_plugin_get_name(plugin);
    snprintf(pedal->name, sizeof(pedal->name), "%s", plugin_name ? lilv_node_as_string(plugin_name) : uri);
    if(plugin_name) lilv_node_free(plugin_name);
    LilvNode *audio = lilv_new_uri(engine->world, CORE "AudioPort");
    LilvNode *control = lilv_new_uri(engine->world, CORE "ControlPort");
    LilvNode *input = lilv_new_uri(engine->world, CORE "InputPort");
    for(uint32_t i = 0; i < lilv_plugin_get_num_ports(plugin); ++i) {
        const LilvPort *port = lilv_plugin_get_port_by_index(plugin, i);
        if(lilv_port_is_a(plugin, port, audio)) {
            if(lilv_port_is_a(plugin, port, input)) pedal->audio_in = i;
            else pedal->audio_out = i;
        } else if(lilv_port_is_a(plugin, port, control)) {
            ControlPort *target = &pedal->controls[pedal->control_count++];
            target->index = i;
            target->input = lilv_port_is_a(plugin, port, input);
            const LilvNode *symbol = lilv_port_get_symbol(plugin, port);
            snprintf(target->symbol, sizeof(target->symbol), "%s", lilv_node_as_string(symbol));
            LilvNode *def = NULL, *min = NULL, *max = NULL;
            lilv_port_get_range(plugin, port, &def, &min, &max);
            target->has_minimum = min != NULL;
            target->has_maximum = max != NULL;
            if(min) target->minimum = lilv_node_as_float(min);
            if(max) target->maximum = lilv_node_as_float(max);
            target->value = def ? lilv_node_as_float(def) : (min ? target->minimum : 0);
            if(def) lilv_node_free(def);
            if(min) lilv_node_free(min);
            if(max) lilv_node_free(max);
        }
    }
    lilv_node_free(audio);
    lilv_node_free(control);
    lilv_node_free(input);
    pedal->instance = lilv_plugin_instantiate(plugin, engine->rate, NULL);
    if(!pedal->instance) {
        snprintf(error, error_size, "could not instantiate LV2 plugin");
        return false;
    }
    connect_controls(pedal);
    lilv_instance_activate(pedal->instance);
    engine->pedal_count++;
    return true;
}

void lv2_process(Engine *engine, Pedal *pedal, const int16_t *input, int16_t *output, size_t count)
{
    for(size_t i = 0; i < count; ++i) engine->lv2_in[i] = (float)input[i] / 32768.0f;
    lilv_instance_connect_port(pedal->instance, pedal->audio_in, engine->lv2_in);
    lilv_instance_connect_port(pedal->instance, pedal->audio_out, engine->lv2_out);
    lilv_instance_run(pedal->instance, (uint32_t)count);
    for(size_t i = 0; i < count; ++i) {
        double sample = nearbyint(engine->lv2_out[i] * 32767.0);
        if(!isfinite(sample)) sample = 0;
        if(sample > 32767) sample = 32767;
        if(sample < -32768) sample = -32768;
        output[i] = (int16_t)sample;
    }
}
