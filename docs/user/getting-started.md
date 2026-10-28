# Getting started

Build the C pedal and start the engine using the commands in the [README](../../README.md). Use `pedal-engine --list-devices` to find ALSA capture and playback devices. The browser panel runs with `pedal-web` and opens at `http://127.0.0.1:8765`.

For a control demo without audio hardware, start `pedal-engine --no-audio --socket /tmp/guitar-effect.sock`, then run `PEDAL_CONTROL_SOCKET=/tmp/guitar-effect.sock ./build/release/pedal-web`.
