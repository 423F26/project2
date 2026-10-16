# LVGL touchscreen preview

This native 800×480 LVGL preview shows the pedal board as an input-to-output signal path. It opens an SDL2 window on a Linux laptop. Mouse drags stand in for touchscreen drags.

## Build and run on a laptop

Install C and C++ compilers, CMake, and SDL2 development files (`libsdl2-dev` on Debian/Raspberry Pi OS). CMake downloads the pinned LVGL v9.6.0 source on the first build.

```bash
cmake -S lvgl_ui -B build/lvgl -DCMAKE_BUILD_TYPE=Release
cmake --build build/lvgl -j 4
./build/lvgl/pedal-lvgl
```

The default demo mode needs no guitar interface or audio process. Drag **Fuzz** or **Overdrive** from the pedal rack onto either board slot. Either slot can be empty, including the left slot while a pedal occupies the right. Drag an active pedal onto the rack to remove it, or to the other slot to move or swap it. Tap the cog on either pedal, including one in the rack, to edit that pedal's Drive, Tone, and Level; Overdrive also has its own Mix. These settings are independent. The **SIGNAL ON/BYPASSED** button bypasses the whole board. The board **MIX** blends the processed chain with the clean signal. Close the window to exit.

## Connect to the running pedal

On the same machine as `pedal effect`, start the UI with:

```bash
./build/lvgl/pedal-lvgl --live
```

It reads and changes the existing `/run/guitar-effect.sock` control interface. The UI shows **PEDAL DISCONNECTED** if the effect process is unavailable. The audio backend follows occupied slots from left to right and crossfades when the audible pedal chain or an active pedal's settings change. Moving a single pedal between slots keeps the same audio path.

The current graph is a serial path: input → zero, one, or two pedals → output. The graph state includes nodes and directed edges so later versions can expand to branching and routing. This desktop SDL2 build is a preview; Pi touchscreen deployment needs a display and input backend matched to the actual screen hardware.
