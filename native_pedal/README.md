# Native C pedal engine

This directory contains the live audio program. `main.c` handles ALSA,
arguments, the local control socket, and JSON state. `dsp.c` processes the five
built-in pedals and serial board. `lv2.c` discovers and hosts compatible LV2
plugins with Lilv. The browser and LVGL interfaces remain separate clients of
the control socket.

On Debian or Raspberry Pi OS, build and test from the repository root:

```bash
sudo apt install cmake build-essential pkg-config libasound2-dev liblilv-dev libjson-c-dev
cmake -S native_pedal -B build/native -DCMAKE_BUILD_TYPE=Release
cmake --build build/native -j
ctest --test-dir build/native --output-on-failure
```

Run `build/native/pedal-engine --help` for options. `uv run pedal effect` is a
compatibility launcher that executes this binary. For an installed binary in
another location, set `PEDAL_ENGINE_BIN` to its path. The default control socket
is `/run/guitar-effect.sock`; set `PEDAL_CONTROL_SOCKET` for both the engine and
clients to use another path. `--no-audio` starts the control server without ALSA
for integration tests.

The host accepts installed mono LV2 effects with one audio input, one audio
output, control ports, and no required host features. The effect is loaded into
the library by `lv2-load URI` or `--lv2 URI`, then added to the board. Importing
or changing a board that contains an LV2 plugin can instantiate plugin code on
the audio thread. Do that while idle; test timing and audio recovery counts on
the target Pi before live use.
