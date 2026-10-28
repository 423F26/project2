# Getting started

## Install

Use Python 3.11 or newer. From the repository root, install the project with `uv` and inspect the CLI:

```bash
uv sync
uv run pedal --help
```

The commands in these guides assume `uv` and the repository root as the working directory. If you installed the package in another Python environment, replace `uv run pedal` with `pedal`. You can also invoke `python -m ml_guitar_pedal.cli`.

Before running the live effect, build its C engine as shown in the [live effect guide](live-effect.md). The classifier commands remain Python tools.

## Choose a workflow

- [Live effect](live-effect.md): Linux ALSA, `libasound.so.2`, and a USB interface with a guitar input and playback output. The Raspberry Pi 3 headphone jack cannot capture guitar audio.
- [Pitch classifier](pitch-classifier.md): labeled integer-PCM WAV files under `data/clean/`. This workflow can run without an audio interface.
- [Audio-to-MIDI](audio-to-midi.md): ALSA `arecord`, a capture device matching the code's fixed settings, and an available MIDI output port.

`footswitch` also requires `gpiomon` from libgpiod, `stdbuf`, and a compatible Raspberry Pi GPIO setup. The browser demo requires a browser on the Pi or an SSH tunnel from another computer.

## First checks

For a live interface, list ALSA devices before starting the effect:

```bash
uv run pedal effect --list-devices
```

For classifier data, check the recording layout before training:

```bash
uv run pedal scan --data data/clean
```

The project ignores `data/` and `models/` in Git. Keep your recordings and trained models backed up separately. The default model path is `models/clean_pitch_knn.json`.
