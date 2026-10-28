# Getting started

Build the C pedal using the commands in the [README](../../README.md). Use `./build/release/pedal-engine --list-devices` to find ALSA capture and playback devices, then start the engine with `--input DEVICE --output DEVICE`. In another terminal, run `./build/release/pedal-web` from the project root and open `http://127.0.0.1:8765`.

For a control demo without audio hardware, run these in separate terminals:

```sh
./build/release/pedal-engine --no-audio --socket /tmp/guitar-effect.sock
PEDAL_CONTROL_SOCKET=/tmp/guitar-effect.sock ./build/release/pedal-web
```

This demo accepts control changes but does not process audio or generate pitch events. Stop both processes with Ctrl+C. If `/run/guitar-effect.sock` is not writable on your system, set `PEDAL_CONTROL_SOCKET` to a writable path for the engine, browser, and `pedalctl`.
