# Build and tests

Run `cmake -S . -B build/release -DCMAKE_BUILD_TYPE=Release`, `cmake --build build/release -j4`, then `ctest --test-dir build/release --output-on-failure`. The core test checks DSP behavior; the protocol test starts an engine without audio and exercises the C client and browser HTTP endpoints.

The LVGL preview has a separate optional build in `lvgl_ui/`; see its README. Hardware audio and GPIO behavior need verification on the target device.
