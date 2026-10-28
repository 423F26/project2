# Build and tests

Run `cmake -S . -B build/release -DCMAKE_BUILD_TYPE=Release`, `cmake --build build/release -j4`, then `ctest --test-dir build/release --output-on-failure`. The protocol test needs permission to create a Unix socket and bind an HTTP port on loopback.

The core test checks engine input limits, the five built-in pedals, board changes, parameter validation, bypass, crossfades, and LV2 audio processing with a local gain fixture. The tuner test uses generated notes at 44.1, 48, and 96 kHz and checks MIDI note changes, silence, queue overflow, validation, and partial draining. The protocol test runs the engine without ALSA and checks CLI commands, browser endpoints, rejected requests, unchanged state after invalid input, and LV2 import through the browser. CTest points Lilv at the fixture bundle in `build/release/lv2/test-gain.lv2`, so the LV2 checks do not depend on plugins installed on the host.

The LVGL preview has a separate optional build in `lvgl_ui/`; see its README. The no-audio protocol test cannot establish real audio quality, latency, GPIO electrical safety, or reliable Pi deployment. Record those results on target hardware before marking those backlog items complete.
