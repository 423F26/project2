# Live audio and control internals

## Native stream path

`native_pedal/main.c` chooses ALSA devices from `/proc/asound/pcm` unless `--input` or `--output` is supplied. It opens mono S16_LE capture and playback with ALSA conversion enabled for `plughw` devices. Defaults are 48 kHz and 128 frames per block. The audio loop polls the control socket, reads one block, calls `engine_process`, and writes the result. ALSA errors use `snd_pcm_recover`; `--meter` reports input RMS, peak, and recovery counts.

`native_pedal/dsp.c` owns the five built-in effects and the ordered board of up to 32 active pedals. Delay and chorus maintain ring buffers; filters and modulation keep state between blocks. Board and setting changes retain an old path and crossfade for 10 ms. Global amount and bypass also fade. `native_pedal/lv2.c` uses Lilv to scan and instantiate installed plugins with one mono audio input, one mono audio output, control ports, and no required host features. Plugins are processed on the same audio thread.

`ml_guitar_pedal/effect.py` only locates and executes the native binary. Build with `cmake -S native_pedal -B build/native -DCMAKE_BUILD_TYPE=Release && cmake --build build/native -j`. Set `PEDAL_ENGINE_BIN` if the binary lives elsewhere. `--no-audio` and `--socket PATH` allow control tests without an ALSA device.

## Local control protocol

The C engine owns `/run/guitar-effect.sock` and accepts one short UTF-8 command per connection. Set `PEDAL_CONTROL_SOCKET` to override the path in the engine, Python clients, and LVGL UI. Replies end with a newline. The socket is removed on normal shutdown.

| Command | Reply | Use |
| --- | --- | --- |
| `status`, `clean`, `effect`, `toggle` | `clean` or `effect` | Mode and footswitch |
| `board <pedals>` | State JSON | Ordered comma-separated names, or `-` for empty |
| `slots <left>,<right>` | State JSON | Legacy two slots; `-` means empty |
| `config <pedal> <setting> <value>` | State JSON | Set one pedal control |
| Built-in pedal name or loaded `lv2-N` | State JSON | Select one pedal |
| `state` | State JSON | Browser and LVGL refresh |
| `amount <0..1>` | State JSON | Global clean/board blend |
| `lv2-list` | Plugin list JSON | Import dialog |
| `lv2-load <URI>` | State JSON | Import installed LV2 effect |

The JSON state includes `enabled`, `amount`, `mode`, `effect_type`, `pedals`, `slots`, `settings`, `available`, and `graph` with nodes and edges. The browser UI and Python mode client use this socket; the LVGL screen sends the same commands directly. Run one engine at a time. The engine rejects an active socket path rather than replacing it.

## Browser and footswitch adapters

`demo_ui.py` binds a `ThreadingHTTPServer` to `127.0.0.1` and forwards API requests to the socket. It starts the C engine through the Python launcher only when no engine responds. It has no authentication, so use an SSH tunnel for remote viewing. `footswitch.py` listens to GPIO17 with `gpiomon` and sends `toggle`.

## Verification

Run CTest, Python tests, and an ALSA loop check with a real interface. Test import with an installed LV2 effect and observe `--meter` while playing. The `null` ALSA device can exercise the loop without physical hardware, but it cannot establish audible quality or Pi performance. Scanning and instantiating an LV2 plugin occur in the audio loop, so importing may briefly interrupt playback; do this while idle. Plugins without `hardRTCapable` may also block inside their process callback.
