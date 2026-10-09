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
| `--tone` | 3000 | Low-pass cutoff in Hz, below half the sample rate |
| `--mix` | 1 | Dry/wet mix, from 0 to 1 |
| `--level` | 0.5 | Effect output level, from 0 to 1 |
| `--clean-level` | 1 | Clean output level, from 0 to 1 |

Try `--block 256` or `--block 512` if audio breaks up. Larger blocks add buffering delay. `--meter` prints input RMS, peak, and ALSA recovery counts about every two seconds.

## Switch between clean and effect

With `pedal effect` running, open a second terminal on the same machine:

```bash
uv run pedal mode
uv run pedal mode clean
uv run pedal mode effect
uv run pedal mode toggle
```

Changes crossfade over 10 ms. The commands use `/run/guitar-effect.sock`. The account running the effect must be able to create this socket in `/run`, and the account running the control command must be able to access it. On systems where a regular account cannot write to `/run`, arrange suitable deployment permissions for that fixed path. Run one effect process at a time.

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

Keep the SSH terminal open and visit `http://127.0.0.1:8765`. The page changes clean/effect mode and effect amount. It binds only to `127.0.0.1` on the Pi. The UI uses an existing effect process if one responds, or starts the effect with default device settings and stops only that process on exit. For a specific interface, start `pedal effect` with `--input` and `--output` first. `demo-ui --port <port>` changes the server port; update the SSH forward to match.

## Troubleshooting

- **No capture or playback device:** reconnect the USB interface, inspect `effect --list-devices` and `arecord -l`, and pass device names explicitly.
- **Socket permission error:** the effect cannot create `/run/guitar-effect.sock`; check the account and `/run` permissions.
- **`pedal effect is not running`:** start the effect on the same machine, then check socket access.
- **Dropouts:** increase `--block` and enable `--meter` to inspect recovery counts.
- **No guitar input from a passive analog iRig on the Pi 3 jack:** that jack has playback output only; use a USB interface with capture input.
