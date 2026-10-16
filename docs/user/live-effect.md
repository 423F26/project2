# Live guitar effect

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
uv run pedal mode board overdrive,fuzz
uv run pedal mode board fuzz,overdrive
uv run pedal mode board -
uv run pedal mode slots -,fuzz
uv run pedal mode config fuzz drive 25
uv run pedal mode config overdrive tone 3500
```

`board` sets the serial order from input to output and fills slots from the left. `slots` sets exact left and right positions; `-` is an empty slot, so `slots -,fuzz` leaves Fuzz in the right slot. The `fuzz` and `overdrive` commands are shortcuts for a board with only that pedal. `config` changes a pedal’s own Drive, Tone, Mix (Overdrive only), or Level. Drive accepts 1–100, Tone accepts 100 Hz up to below half the audio sample rate, and Mix and Level accept 0–1. `effect` enables the board; `clean` bypasses it. Audible changes crossfade over 10 ms. The commands use `/run/guitar-effect.sock`. The account running the effect must be able to create this socket in `/run`, and the account running the control command must be able to access it. On systems where a regular account cannot write to `/run`, arrange suitable deployment permissions for that fixed path. Run one effect process at a time.

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

Keep the SSH terminal open and visit `http://127.0.0.1:8765`. The page adds or removes fuzz and overdrive, reverses their slot positions, opens each pedal’s cog settings, bypasses the board, and adjusts the global mix. It binds only to `127.0.0.1` on the Pi. When the UI starts the effect, it captures from the first available input and plays through ALSA's system default output. Set the Pi's system default to its built-in audio output to hear the demo there instead of through the iRig, or use `demo-ui --output <ALSA-device>` to select a specific output. An already-running effect keeps its current output; stop it first or launch `pedal effect` with explicit `--input` and `--output` options. The UI stops only an effect process it started. `demo-ui --port <port>` changes the server port; update the SSH forward to match.

## LVGL pedal board preview

The [LVGL desktop preview](../../lvgl_ui/README.md) lets you drag Fuzz and Overdrive between a rack and either board slot. You can leave the left slot empty. Tap a pedal’s cog for its own settings. In demo mode, no audio device is needed; use `./build/lvgl/pedal-lvgl --live` on the same machine as the running effect to control audio.

## Troubleshooting

- **No capture or playback device:** reconnect the USB interface, inspect `effect --list-devices` and `arecord -l`, and pass device names explicitly.
- **Socket permission error:** the effect cannot create `/run/guitar-effect.sock`; check the account and `/run` permissions.
- **`pedal effect is not running`:** start the effect on the same machine, then check socket access.
- **Dropouts:** increase `--block` and enable `--meter` to inspect recovery counts.
- **No guitar input from a passive analog iRig on the Pi 3 jack:** that jack has playback output only; use a USB interface with capture input.
