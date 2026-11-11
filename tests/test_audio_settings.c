#include "audio_settings.h"
#include <assert.h>
#include <stdio.h>

int main(void)
{
    const char *valid[] = {"{\"volume_db\":-12}", "{\"volume_db\":0,\"input_gain_db\":32,\"muted\":false}", "{\"volume_db\":-60,\"input_gain_db\":-12,\"muted\":true}"};
    const char *invalid[] = {"{}", "[]", "{\"volume_db\":1}", "{\"volume_db\":-61}", "{\"input_gain_db\":33}", "{\"input_gain_db\":-13}", "{\"volume_db\":\"0\"}", "{\"volume_db\":null}", "{\"volume_db\":NaN}", "{\"muted\":1}", "{\"muted\":\"false\"}", "{\"mic_bias\":true}", "{\"vcom\":1}", "{\"volume_db\":-12,\"register\":2}"};
    char error[200];
    for(size_t i = 0; i < sizeof(valid)/sizeof(*valid); ++i) {
        json_object *settings = json_tokener_parse(valid[i]);
        if(!audio_settings_validate(settings, error, sizeof(error))) { fprintf(stderr, "Rejected valid settings: %s\n", error); return 1; }
        json_object_put(settings);
    }
    for(size_t i = 0; i < sizeof(invalid)/sizeof(*invalid); ++i) {
        json_object *settings = json_tokener_parse(invalid[i]);
        if(audio_settings_validate(settings, error, sizeof(error))) { fprintf(stderr, "Accepted invalid settings: %s\n", invalid[i]); return 1; }
        if(settings) json_object_put(settings);
    }
    puts("Audio control ranges, JSON types and register access restrictions passed.");
    return 0;
}
