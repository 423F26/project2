# Audio-to-MIDI volume trigger

```bash
uv run pedal audio-to-midi
```

This experimental command reads ALSA audio through `arecord` and sends a fixed MIDI note. It does not detect the played pitch or use the trained classifier.

The current device and thresholds are constants in `ml_guitar_pedal/audio_to_midi.py`:

| Setting | Value |
| --- | --- |
| Capture device | `hw:2,0` |
| Capture format | Stereo S32_LE, 44,100 Hz, 1,024-frame blocks |
| MIDI output | Port index 0 |
| Note on | RMS above 0.03: note 60 (C4), velocity 100 |
| Note off | RMS below 0.015 |

Install `alsa-utils` for `arecord`, inspect capture devices with `arecord -l`, and ensure an output MIDI port exists. The command has no CLI options for changing these settings. Use `alsamixer` if input level needs adjustment. Press Ctrl+C to stop; cleanup releases an active note.

For optional software-synth playback, start FluidSynth with a SoundFont installed on the target machine, run `aconnect -l`, then connect the port IDs actually listed there. Device names, port IDs, and SoundFont paths vary by system.
