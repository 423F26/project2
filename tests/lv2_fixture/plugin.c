#include <lv2/core/lv2.h>
#include <stdlib.h>

#define URI "https://example.org/c-pedal/test-gain"

typedef struct {
    const float *input;
    float *output;
    const float *gain;
} Fixture;

static LV2_Handle instantiate(const LV2_Descriptor *descriptor, double rate,
                              const char *bundle_path, const LV2_Feature *const *features)
{
    (void)descriptor; (void)rate; (void)bundle_path; (void)features;
    return calloc(1, sizeof(Fixture));
}

static void connect_port(LV2_Handle handle, uint32_t port, void *data)
{
    Fixture *fixture = handle;
    if(port == 0) fixture->input = data;
    else if(port == 1) fixture->output = data;
    else if(port == 2) fixture->gain = data;
}

static void run(LV2_Handle handle, uint32_t count)
{
    Fixture *fixture = handle;
    for(uint32_t i = 0; i < count; ++i)
        fixture->output[i] = fixture->input[i] * *fixture->gain;
}

static void cleanup(LV2_Handle handle) { free(handle); }

static const LV2_Descriptor descriptor = {
    URI, instantiate, connect_port, NULL, run, NULL, cleanup, NULL
};

LV2_SYMBOL_EXPORT const LV2_Descriptor *lv2_descriptor(uint32_t index)
{
    return index == 0 ? &descriptor : NULL;
}
