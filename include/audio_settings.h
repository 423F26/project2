#ifndef PEDAL_AUDIO_SETTINGS_H
#define PEDAL_AUDIO_SETTINGS_H

#include <json-c/json.h>
#include <stdbool.h>
#include <stddef.h>

/* Fixed ADAC mixer controls, called by UI processes, never the audio thread. */
json_object *audio_settings_read(void);
bool audio_settings_validate(json_object *settings, char *error, size_t size);
bool audio_settings_apply(json_object *settings, char *error, size_t size);
bool audio_settings_restore(char *error, size_t size);

#endif
