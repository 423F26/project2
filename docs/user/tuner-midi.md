# Tuner and MIDI events

The tuner listens to the mono guitar input before Overdrive, Fuzz, or other effects. Expand **Tuner** at the bottom of the browser panel, play one note, and read the nearest note name, detected frequency, and cents flat or sharp. The center of the meter is in tune within 5 cents. Tuning uses A4 = 440 Hz and detects roughly 65–1200 Hz. It needs about 100 ms of stable signal before a new reading appears; noisy or polyphonic input may not yield a reliable note.

Tracking is on by default. Use the browser's **Tuner** switch, `pedalctl tuner off`, or `pedal-engine --no-tuner` to disable it. Disabling tracking sends a note-off for any active internal MIDI note.

The tuner generates MIDI note on/off events internally after the pitch stabilizes. Read and consume them with `pedalctl midi-events` or `GET /api/midi` on the localhost browser server. Each event has a frame timestamp and `status`, `data1`, and `data2` MIDI bytes. A note-on uses status `144` (channel 1), the detected MIDI note number, and a velocity derived from signal level; note-off uses status `128` and velocity zero. Reading events drains the queue, so use one consumer. The queue holds 256 events and reports any dropped events.

This is an internal event API; it does not yet send MIDI to an ALSA sequencer port or a physical MIDI device.
