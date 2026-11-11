# LVGL touchscreen preview

This native 800×480 LVGL preview shows the pedal board as an input-to-output signal path. It opens an SDL2 window on a Linux laptop. Mouse drags stand in for touchscreen drags.

On the ADAC-equipped Raspberry Pi, run `./scripts/install-pi-desktop.sh --autostart`
from the repository root to install **Riffline** on the desktop and launch it
after automatic desktop login. Both entries use `run-pedal.sh`, which builds the
current sources, selects ADAC for capture/playback, restores the saved pedal
settings, and opens the native UI fullscreen. Escape closes it. Use
`./run-pedal.sh --preview --windowed` for an audio-free window, or
`./run-pedal.sh --check` to build and check ADAC without opening the UI.

## Build and run on a laptop

Install C and C++ compilers, CMake, and SDL2 development files (`libsdl2-dev` on Debian/Raspberry Pi OS). CMake downloads the pinned LVGL v9.6.0 source on the first build.

```bash
cmake -S lvgl_ui -B build/lvgl -DCMAKE_BUILD_TYPE=Release
cmake --build build/lvgl -j 4
./build/lvgl/pedal-lvgl
```

The default demo mode needs no guitar interface or audio process. Open **PEDAL LIBRARY** to add Overdrive, Fuzz, Delay, Tremolo, Chorus, Limiter, and Octave. The active board fits all seven pedals. Drag a pedal across the board to reorder it, or drag it down to remove it. Tap its cog to edit its controls. The **SIGNAL ON/BYPASSED** button bypasses the chain, and **MIX** blends it with the clean signal. Close the window to exit.

## Connect to the running pedal

On the same machine as `pedal-engine`, start the UI with:

```bash
./build/lvgl/pedal-lvgl --live
```

It reads and changes the existing `/run/guitar-effect.sock` control interface. The UI shows **PEDAL DISCONNECTED** if the effect process is unavailable. The audio backend follows the active chain from left to right and crossfades when its order or a pedal setting changes.

The native UI includes the bundled Octave effect and per-pedal bypass controls.
Other loaded LV2 effects are available through the browser UI and CLI. The graph
is a serial path: input → active pedals → output. The SDL2 display and touch input
backend has been deployed on the Pi's graphical desktop.

## Tuner and limiter

Tap **TUNER** beside **AUDIO** to see the clean input note, frequency and cents
relative to A4 = 440 Hz. The display refreshes five times per second while open.
Tracking can be switched off independently; opening the tuner keeps audio playing.
`./run-pedal.sh --tuner` opens directly to this panel.

Add **LIMITER** from the library and drag it to the end of the board for output
peak control. Its ceiling ranges from -36 to 0 dBFS (default -1 dBFS), and release
from 5 to 1000 ms (default 80 ms). Attack is immediate, with no lookahead buffer
or makeup gain. Once the normal 10 ms control crossfade completes, processed
samples respect the ceiling. It cannot undo clipping in an earlier pedal or in
the ADC, and does not remove hum.
Global bypass or a dry mix can pass peaks above the limiter ceiling.
