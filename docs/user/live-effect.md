# Live guitar effect

The audio engine, built-in effects, ALSA streaming, LV2 hosting, and control
socket run in C. Build it before using `pedal effect`:

```bash
sudo apt install cmake build-essential pkg-config libasound2-dev liblilv-dev libjson-c-dev
cmake -S native_pedal -B build/native -DCMAKE_BUILD_TYPE=Release
cmake --build build/native -j
```

The Python `pedal` command launches the compiled `build/native/pedal-engine`.
You can also run that binary directly with the same options. Rebuild after
changing native source files.

## Audio setup

Connect the guitar to a USB audio interface capture input and headphones or speakers to a playback output. On the Linux machine with the interface, list the available ALSA names, then pass the appropriate capture and playback names:

```bash
uv run pedal effect --list-devices
uv run pedal effect --input plughw:1,0 --output plughw:1,0
```

`plughw:1,0` is an example; device numbers vary. Without `--input` or `--output`, the command picks the first capture device and its matching playback device when available, otherwise the first playback device. The default audio format is mono 16-bit PCM at 48 kHz in 128-frame blocks. The effect starts on. Press Ctrl+C to stop.

| Option | Default | Meaning |
| --- | ---: | --- |
| `--rate` | 48000 | ALSA sample rate in Hz; at least 8000 |
| `--block` | 128 | Frames per read; at least 16 |
| `--drive` | 20 | Overdrive gain; at least 1 |
| `--tone` | 3000 | Overdrive low-pass cutoff in Hz, below half the sample rate |
| `--mix` | 1 | Overdrive dry/wet mix, from 0 to 1 |
| `--level` | 0.5 | Overdrive output level, from 0 to 1 |
| `--fuzz-drive` | 15 | Fuzz input gain; at least 1 |
| `--fuzz-tone` | 2500 | Fuzz low-pass cutoff in Hz, below half the sample rate |
| `--fuzz-level` | 0.45 | Fuzz output level, from 0 to 1 |
| `--clean-level` | 1 | Clean output level, from 0 to 1 |

Try `--block 256` or `--block 512` if audio breaks up. Larger blocks add buffering delay. `--meter` prints input RMS, peak, and ALSA recovery counts about every two seconds.

## Build the pedal signal path

With `pedal effect` running, open a second terminal on the same machine:

```bash
uv run pedal mode
uv run pedal mode clean
uv run pedal mode effect
uv run pedal mode toggle
uv run pedal mode fuzz
uv run pedal mode overdrive
uv run pedal mode delay
uv run pedal mode tremolo
uv run pedal mode chorus
uv run pedal mode board overdrive,fuzz
uv run pedal mode board fuzz,overdrive
uv run pedal mode board overdrive,fuzz,delay,tremolo,chorus
uv run pedal mode board -
uv run pedal mode config fuzz drive 25
uv run pedal mode config overdrive tone 3500
uv run pedal mode config delay time 450
uv run pedal mode config tremolo rate 6
uv run pedal mode config chorus depth 0.7
```

`board` sets the ordered signal path from input to output. It grows or shrinks with the active pedals, up to 32; `board -` clears it. The older `slots` command remains available for scripts that use explicit empty positions. Each built-in pedal name is a shortcut for a board with only that pedal. `config` changes each pedal’s controls. Overdrive and Fuzz use Drive (1–100), Tone (100 Hz up to below half the sample rate), Level (0–1), and Overdrive Mix (0–1). Delay has Time (20–1500 ms), Feedback (0–0.9), and Mix (0–1). Tremolo has Rate (0.1–20 Hz) and Depth (0–1). Chorus has Rate (0.1–5 Hz), Depth (0–1), and Mix (0–1). `effect` enables the board; `clean` bypasses it. Audible changes crossfade over 10 ms. The commands use `/run/guitar-effect.sock`. The account running the effect must be able to create this socket in `/run`, and the account running the control command must be able to access it. On systems where a regular account cannot write to `/run`, arrange suitable deployment permissions for that fixed path. Run one effect process at a time.

## LV2 effects

To install an effect from the [LV2 plugin catalog](https://github.com/alex-tee/lv2-plugins-ultimate-list), find its URI, and load it into the pedal library, follow [Add LV2 plugins](lv2-plugins.md).

## Footswitch

For the Raspberry Pi 3 wiring assumed by the code, connect a normally open momentary switch between GPIO17 (physical pin 11) and ground (physical pin 9). The software requests an internal pull-up; do not wire the switch to a voltage pin. With the effect running, start the listener in another terminal:

```bash
uv run pedal footswitch
```

It invokes `gpiomon` on `gpiochip0` line 17, using falling edges and a 50 ms debounce. The line mapping and supported `gpiomon` options may differ on other Pi models or libgpiod versions.

## Browser control over SSH

On your computer, replace the host and path with the target Pi values:

```bash
ssh -L 8765:127.0.0.1:8765 pi-host 'cd /path/to/project2 && uv run pedal demo-ui'
```

Keep the SSH terminal open and visit `http://127.0.0.1:8765`. The page shows an active board and searchable pedal library. Use **Import effect** to load compatible installed LV2 plugins, then add or remove pedals, move them left or right, open each pedal’s cog settings, bypasses the board, and adjusts the global mix. It binds only to `127.0.0.1` on the Pi. When the UI starts the effect, it captures from the first available input and plays through ALSA's system default output. Set the Pi's system default to its built-in audio output to hear the demo there instead of through the iRig, or use `demo-ui --output <ALSA-device>` to select a specific output. An already-running effect keeps its current output; stop it first or launch `pedal effect` with explicit `--input` and `--output` options. The UI stops only an effect process it started. `demo-ui --port <port>` changes the server port; update the SSH forward to match.

## LVGL pedal board preview

The [LVGL desktop preview](../../lvgl_ui/README.md) has a library menu for the five built-in pedals. The active board expands as you add them. Drag pedals across the board to reorder or down to remove them. Tap a pedal’s cog for its settings. In demo mode, no audio device is needed; use `./build/lvgl/pedal-lvgl --live` on the same machine as the running effect to control audio.

## Troubleshooting

- **No capture or playback device:** reconnect the USB interface, inspect `effect --list-devices` and `arecord -l`, and pass device names explicitly.
- **Socket permission error:** the effect cannot create `/run/guitar-effect.sock`; check the account and `/run` permissions.
- **`pedal effect is not running`:** start the effect on the same machine, then check socket access.
- **Dropouts:** increase `--block` and enable `--meter` to inspect recovery counts.
- **No guitar input from a passive analog iRig on the Pi 3 jack:** that jack has playback output only; use a USB interface with capture input.
