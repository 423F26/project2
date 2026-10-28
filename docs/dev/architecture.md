# C pedal architecture

`src/engine.c` owns ALSA capture/playback, the local command socket, and JSON state. `src/dsp.c` implements built-in effects and serial board transitions. `src/lv2.c` uses Lilv to discover and process compatible LV2 effects. `src/socket_client.c` is shared by `pedalctl`, `pedal-web`, and `pedal-footswitch`. `web/index.html` is the browser control panel. `lvgl_ui/` is an optional C touchscreen preview.

The active board is an ordered list of pedal IDs. The engine crossfades when the board or settings change. The browser sends JSON to a localhost C HTTP adapter, which translates it to the engine's Unix socket protocol.
