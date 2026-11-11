#include "audio_settings.h"
#include <stdio.h>
#include <string.h>

int main(int argc, char **argv)
{
    char error[200];
    if(argc == 2 && strcmp(argv[1], "restore") == 0) {
        if(audio_settings_restore(error, sizeof(error))) return 0;
        fprintf(stderr, "%s\n", error);
        return 1;
    }
    if(argc > 2 || (argc == 2 && strcmp(argv[1], "state") != 0)) {
        fprintf(stderr, "Usage: pedal-audio [state|restore]\n");
        return 2;
    }
    json_object *state = audio_settings_read();
    puts(json_object_to_json_string_ext(state, JSON_C_TO_STRING_PRETTY));
    json_object_put(state);
    return 0;
}
