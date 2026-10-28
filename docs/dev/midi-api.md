# Internal MIDI API

`include/midi.h` defines `MidiEvent` and `MidiQueue`. A MIDI event has a 64-bit input-frame timestamp and a channel-voice `status`, `data1`, and `data2`. Use `midi_queue_push()` to add an event and `midi_queue_drain()` to consume events in order. The fixed 256-event ring drops the oldest event on overflow and increments `dropped`. Program change and channel pressure use `data2 = 0`.

The queue has no internal locking. The current engine calls it from one thread; other C users must synchronize producer and consumer access if they use different threads. The installed `libpedal_pitch.a` and `include/c-pedal/{midi,tuner}.h` provide the reusable C API.

`include/tuner.h` exposes `tuner_init()`, `tuner_set_enabled()`, `tuner_process()`, and `tuner_note_name()`. `engine_process()` feeds input samples into the tuner before processing effects. The tuner decimates toward 12 kHz, analyzes a 768-sample window with a cumulative normalized difference, and uses a short stability check before emitting a MIDI note-on. Pitch changes emit note-off then note-on; silence and disabling tracking emit note-off. The sample-rate independent input frame counter timestamps events.

`pedalctl state` reads the current pitch and queue depth. `pedalctl midi-events` drains the queue through the Unix socket. The equivalent browser HTTP endpoint is `GET /api/midi`. The queue is single-consumer: multiple pollers will split events. An external ALSA MIDI bridge can consume these events later without changing the tuner.

The MIDI queue is also a boundary for future ML note-on and pitch models. Such a model can be compared to the deterministic tuner without replacing the effect engine or the event transport.
