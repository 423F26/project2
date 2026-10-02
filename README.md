# ML Guitar Pedal

Live Raspberry Pi guitar effects, plus pitch-classifier tooling for the labeled
clean-tone recordings under `data/clean/`.

## Setup

```bash
uv sync
```

## Live guitar effect

Connect a USB audio interface with a guitar input and headphone/line output, then run:

```bash
uv run pedal effect --list-devices
uv run pedal effect
```

### Browser demo over SSH

From the computer connected to the Pi, run:

```bash
ssh -F ~/.ssh/config -L 8765:127.0.0.1:8765 pi 'cd /root/project2 && uv run pedal demo-ui'
```

Keep that SSH terminal open and visit `http://127.0.0.1:8765` in a browser.
The page has a clean/effect button and a live effect-amount slider. The demo
uses the running pedal if one is already active, or starts it if needed. When
the SSH command ends, it stops only an effect process that it started itself.

The `effect` command processes the guitar input with overdrive and a tone filter,
then plays it through the interface output. It chooses the first capture device
and its matching playback device when available. To select devices explicitly:

```bash
uv run pedal effect --input plughw:1,0 --output plughw:1,0 --block 128 --drive 20 --tone 3000 --mix 1 --level 0.5
```

While the effect is running, use another terminal on the Pi to switch instantly:

```bash
uv run pedal mode toggle  # switch clean/effect
uv run pedal mode clean   # clean guitar
uv run pedal mode effect  # overdrive
uv run pedal mode         # show current mode
```

The change fades over 10 ms to avoid a click, and audio keeps streaming.

For a physical toggle on a Raspberry Pi 3, connect a normally open momentary
switch between GPIO17 (physical header pin 11) and ground (physical pin 9).
The internal pull-up is enabled in software; do not connect a voltage pin to the
switch. Run the listener in a second terminal while `pedal effect` runs:

```bash
uv run pedal footswitch
```

Each press switches between clean and overdrive. The listener uses `gpiomon`
from `libgpiod` and a 50 ms debounce period.

The default 128-frame block reduces delay; increase `--block` to 256 or 512 if
audio breaks up. Add `--meter` to print input level and ALSA recovery counts.
Press Ctrl+C to stop. A passive analog iRig connected to the Pi's 3.5 mm jack cannot work as
an input because the Raspberry Pi 3 jack only provides audio output; use a USB
audio interface with a guitar input in that case.

## Live audio to MIDI

```bash
uv run pedal audio-to-midi
```

This uses Linux ALSA's `arecord` (provided by `alsa-utils`) and the first
available MIDI output port. It captures stereo S32_LE audio from `hw:2,0` at
44,100 Hz in 1,024-frame blocks. Volume above 0.03 triggers MIDI note 60 (C4)
at velocity 100; volume below 0.015 releases it. This is a fixed-note volume
trigger, not pitch-to-MIDI transcription. Press Ctrl+C to stop.

Use `alsamixer` to adjust input volume. For FluidSynth playback, start a synth
in another terminal (adjust the audio device and SoundFont path as needed):

```bash
fluidsynth -a alsa -o audio.alsa.device=hw:1,0 /usr/share/sounds/sf2/TimGM6mb.sf2
aconnect -l
aconnect 14:0 128:0
```

Use the actual source and destination port IDs shown by `aconnect -l`.
You can also run the module: `uv run python -m ml_guitar_pedal.audio_to_midi`.

## Dataset

The `data/clean/` directory is expected to contain pickup-position folders with
files named as `string-fret.wav`, for example `data/clean/Bridge/6-0.wav`.

The classifier converts those names to standard-tuning pitches:

- string 6: E2
- string 5: A2
- string 4: D3
- string 3: G3
- string 2: B3
- string 1: E4

## Commands

Start the interactive CLI:

```bash
uv run pedal
```

You can still start it through the module path:

```bash
uv run python -m ml_guitar_pedal.cli interactive
```

Summarize the clean-tone dataset:

```bash
uv run pedal scan
```

Train and evaluate a KNN pitch classifier:

```bash
uv run pedal train
```

Predict one or more WAV files:

```bash
uv run pedal predict data/clean/Bridge/6-0.wav
```

Benchmark classification latency:

```bash
uv run pedal benchmark
```

The benchmark reports classifier-only latency and feature-extraction plus
classifier latency. The current future hardware target is p95 under 30 ms on a
Raspberry Pi. It also reports a streaming-frame path using short overlapping
frames, defaulting to a 64 ms frame and 32 ms hop. Add `--include-io` to include
WAV reading in the measured path.

```bash
uv run pedal benchmark --stream-frame 0.064 --stream-hop 0.032
```

The default trained model is written to `models/clean_pitch_knn.json`. The
`artifacts/` directory name is intentionally left available for agile/class
project artifacts.

Inside the interactive CLI, use `help` to list commands. The core commands are
`scan`, `train`, `predict <wav>`, `benchmark`, `settings`, and `quit`.

## Tests

```bash
uv run python -m unittest discover -s tests
```
