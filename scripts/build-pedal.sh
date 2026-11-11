#!/usr/bin/env bash
# Incremental builds ensure launchers use the source in this checkout.
set -euo pipefail
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
jobs="${PEDAL_BUILD_JOBS:-2}"
cmake -S "$root" -B "$root/build/release" -DCMAKE_BUILD_TYPE=Release
cmake --build "$root/build/release" --parallel "$jobs" \
    --target pedal-engine pedalctl pedal-web pedal-footswitch pedal-octave
cmake -S "$root/lvgl_ui" -B "$root/build/lvgl" -DCMAKE_BUILD_TYPE=Release \
    -DFETCHCONTENT_UPDATES_DISCONNECTED=ON
cmake --build "$root/build/lvgl" --parallel "$jobs" --target pedal-lvgl
