# LVGL touchscreen preview

This native 800×480 LVGL preview shows the pedal board as an input-to-output signal path. It opens an SDL2 window on a Linux laptop. Mouse drags stand in for touchscreen drags.

## Build and run on a laptop

Install C and C++ compilers, CMake, and SDL2 development files (`libsdl2-dev` on Debian/Raspberry Pi OS). CMake downloads the pinned LVGL v9.6.0 source on the first build.

```bash
cmake -S lvgl_ui -B build/lvgl -DCMAKE_BUILD_TYPE=Release
cmake --build build/lvgl -j 4
./build/lvgl/pedal-lvgl
```

The default demo mode needs no guitar interface or audio process. Open **PEDAL LIBRARY** to add Overdrive, Fuzz, Delay, Tremolo, and Chorus. The active board grows to show all five built-in pedals. Drag a pedal across the board to reorder it, or drag it down to remove it. Tap its cog to edit its controls. The **SIGNAL ON/BYPASSED** button bypasses the chain, and **MIX** blends it with the clean signal. Close the window to exit.

## Connect to the running pedal

On the same machine as `pedal-engine`, start the UI with:

```bash
./build/lvgl/pedal-lvgl --live
```

It reads and changes the existing `/run/guitar-effect.sock` control interface. The UI shows **PEDAL DISCONNECTED** if the effect process is unavailable. The audio backend follows the active chain from left to right and crossfades when its order or a pedal setting changes.

Loaded LV2 effects are available through the browser UI and CLI; the native preview shows built-in pedals. The current graph is a serial path: input → active pedals → output. The native view displays up to five built-in pedals; use the browser UI for chains containing LV2 effects or more pedals. This desktop SDL2 build is a preview; Pi touchscreen deployment needs a display and input backend matched to the actual screen hardware.
