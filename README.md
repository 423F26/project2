# C Pedal

A C guitar pedal engine with a dynamic serial board, five built-in effects, LV2 effect loading, a browser control panel, and a GPIO footswitch adapter. The built-in effects are Overdrive, Fuzz, Delay, Tremolo, and Chorus. The board grows with the pedals you activate.

## Build

On Debian or Raspberry Pi OS, install `cmake`, `pkg-config`, `libasound2-dev`, `liblilv-dev`, `libjson-c-dev`, `jq`, and `curl`. Then:

```sh
cmake -S . -B build/release -DCMAKE_BUILD_TYPE=Release
cmake --build build/release -j 4
ctest --test-dir build/release --output-on-failure
```

## Run

```sh
./build/release/pedal-engine --list-devices
./build/release/pedal-engine --input plughw:1,0 --output plughw:1,0
```

In another terminal, from the project root:

```sh
./build/release/pedal-web
```

Open `http://127.0.0.1:8765`. The **Pedal library** lets you add, reorder, configure, and remove effects. **Import effect** lists compatible LV2 effects already installed on the machine. The browser binds to localhost; use an SSH tunnel for remote access: `ssh -L 8765:127.0.0.1:8765 pi-host`.

The engine socket defaults to `/run/guitar-effect.sock`. Set `PEDAL_CONTROL_SOCKET` in both processes to use another path. For a laptop control demo without audio hardware, start the engine with `--no-audio --socket /tmp/guitar-effect.sock` and set `PEDAL_CONTROL_SOCKET=/tmp/guitar-effect.sock` before launching the web server or client.

```sh
./build/release/pedalctl state
./build/release/pedalctl board overdrive,fuzz,delay
./build/release/pedalctl config delay time 450
./build/release/pedalctl amount 0.7
./build/release/pedalctl toggle
./build/release/pedalctl lv2-list
./build/release/pedalctl lv2-load 'http://example.org/plugin-uri'
```

`pedal-footswitch` uses `gpiomon` from libgpiod to toggle the effect on GPIO 17. See [LV2 installation and import](docs/user/lv2-plugins.md), [live controls](docs/user/live-effect.md), [C architecture](docs/dev/architecture.md), and [LVGL preview](lvgl_ui/README.md).
