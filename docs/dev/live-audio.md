# Live audio and control internals

## Stream path

`effect.py` reads device names from `/proc/asound/pcm` through `alsa_pcm.available_devices()`. It chooses the first capture device unless `--input` is provided, then prefers the matching playback device unless `--output` is provided. `AlsaPcm` opens both streams through `libasound.so.2` as mono S16_LE with ALSA conversion enabled for `plughw` devices. The default is 48 kHz and 128 frames per block.

Each loop polls the control socket, reads capture frames, optionally updates the meter, processes the block, and writes it to playback. `Overdrive` applies tanh shaping and a one-pole low-pass filter. `SwitchableEffect` blends processed output with the clean signal and changes the blend over 10 ms after a mode or amount command. ALSA read/write errors use `snd_pcm_recover`; `--meter` reports recovery counts.

## Local control protocol

`ModeServer` binds `/run/guitar-effect.sock` and accepts one short UTF-8 command per connection. Replies end with a newline. Supported commands are:

| Command | Reply | Used by |
| --- | --- | --- |
| `status`, `clean`, `effect`, `toggle` | `clean` or `effect` | `pedal mode`; footswitch uses `toggle` |
| `state` | JSON with `enabled`, `amount`, and `mode` | Browser UI |
| `amount <0..1>` | Updated state JSON | Browser slider |

The effect process owns the socket and removes it on normal exit. Creating the socket requires write access to `/run`; clients require permission to connect. `pedal mode` has no remote transport or socket-path option. Starting a second effect process against the same socket is unsafe because the server unlinks the existing path before binding.

## GPIO and browser adapters

`footswitch.py` launches `stdbuf -oL gpiomon --chip gpiochip0 --bias pull-up --edges falling --debounce-period 50ms 17`. Each event sends `toggle` to the local socket. Confirm the line mapping and CLI flags on the target Pi.

`demo_ui.py` binds a `ThreadingHTTPServer` to `127.0.0.1` (port 8765 by default) and uses the same socket. Its endpoints are `GET /api/state`, `POST /api/mode` with a boolean `enabled`, and `POST /api/amount` with a number from 0 to 1. It starts a default effect subprocess only when no server responds, and terminates only the subprocess it started. Use an SSH tunnel for access from another machine; the HTTP server has no authentication.

## Hardware check after changes

On the target Pi, list devices, run the effect with explicit input and output, confirm clean/effect/amount changes, and monitor recoveries while playing. Test the browser and footswitch separately if those adapters changed. The 30 ms p95 value printed by the classifier benchmark does not measure this stream's end-to-end audio latency.
