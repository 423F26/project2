# ML Guitar Pedal

Python tools for two separate workflows: a live Raspberry Pi guitar overdrive
effect, and an offline K-nearest-neighbors (KNN) pitch classifier for labeled
clean-tone recordings under `data/clean/`. The live effect does not load or use
the trained classifier. An experimental audio-to-MIDI command triggers a fixed
note from volume; it does not transcribe pitch.

## Documentation

- [User guides](docs/user/README.md): setup, live effect, pitch classifier, and audio-to-MIDI.
- [Developer guides](docs/dev/README.md): architecture, development checks, live control, and classifier internals.
- [Agile plan](docs/agile/README.md): the current project backlog, ESOF-aligned sprint plan, and burndown.

## Requirements and setup

Use Python 3.11 or newer and [uv](https://docs.astral.sh/uv/). Run commands
from the repository root. `uv sync` installs the Python dependencies from
`pyproject.toml` and `uv.lock`. On a target Pi, the live effect also needs Linux
ALSA, `libasound.so.2`, and a USB interface with a guitar capture input and
headphone or line playback output. `footswitch` additionally needs `gpiomon`
from libgpiod and `stdbuf` from GNU coreutils. `audio-to-midi` needs ALSA's
`arecord` from `alsa-utils` and an available MIDI output port.

```bash
uv sync
uv run pedal --help
```

With the package installed in another Python environment, use `pedal` instead
of `uv run pedal`. The module entry point is `python -m ml_guitar_pedal.cli`.

## Live guitar effect

Connect the interface, then run on the Linux machine with the interface:

```bash
uv run pedal effect --list-devices
uv run pedal effect --input plughw:1,0 --output plughw:1,0
```

Use the device names printed by `--list-devices`; `plughw:1,0` is only an
example. The default capture and playback format is mono 16-bit PCM at 48 kHz
in 128-frame blocks. Press Ctrl+C to stop.

### Browser demo over SSH

From the computer connected to the Pi, replace the host and project path with
your own, then run:

```bash
ssh -L 8765:127.0.0.1:8765 pi-host 'cd /path/to/project2 && uv run pedal demo-ui'
```

Keep that SSH terminal open and visit `http://127.0.0.1:8765` in a browser.
The page has a clean/effect button and a live effect-amount slider. The demo
uses the running pedal if one is already active, or starts it if needed. When
the SSH command ends, it stops only an effect process that it started itself.
The UI binds to `127.0.0.1` on the Pi. Its default port is 8765; if you set
`--port`, update the SSH tunnel as well. If you need nondefault ALSA devices,
start `pedal effect` with those devices before opening the UI.

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
The effect and control commands communicate through `/run/guitar-effect.sock`.
The effect process must be able to create a socket there, and control/UI
processes need access to it. On systems where a regular account cannot write
to `/run`, arrange appropriate deployment permissions for this fixed path
before starting the effect. Run one effect process at a time.

For a physical toggle on a Raspberry Pi 3, connect a normally open momentary
switch between GPIO17 (physical header pin 11) and ground (physical pin 9).
The internal pull-up is enabled in software; do not connect a voltage pin to the
switch. Run the listener in a second terminal while `pedal effect` runs:

```bash
uv run pedal footswitch
```

Each press switches between clean and overdrive. The listener uses `gpiomon`
from `libgpiod` with a pull-up, falling edges, and a 50 ms debounce on
`gpiochip0` line 17. GPIO numbering and libgpiod CLI support can vary
across Raspberry Pi models and operating system versions.

The default 128-frame block reduces delay; increase `--block` to 256 or 512 if
audio breaks up. Add `--meter` to print input level and ALSA recovery counts.
Press Ctrl+C to stop. A passive analog iRig connected to the Pi's 3.5 mm jack cannot work as
an input because the Raspberry Pi 3 jack only provides audio output; use a USB
audio interface with a guitar input in that case.

## Live audio to MIDI

```bash
uv run pedal audio-to-midi
```

This uses Linux ALSA's `arecord` (provided by `alsa-utils`) and MIDI output
port index 0. It captures stereo S32_LE audio from hard-coded `hw:2,0` at
44,100 Hz in 1,024-frame blocks. Volume above 0.03 triggers MIDI note 60 (C4)
at velocity 100; volume below 0.015 releases it. This is a fixed-note volume
trigger, not pitch-to-MIDI transcription. The capture device, thresholds, and
port index are constants in `ml_guitar_pedal/audio_to_midi.py`, not CLI
options. Check `arecord -l` and available MIDI ports before use. Press Ctrl+C
to stop; cleanup sends note-off if needed.

Use `alsamixer` to adjust input volume. For optional FluidSynth playback,
start a synth in another terminal (adjust the audio device and SoundFont path):

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
The scan reads one folder below the data root, silently skips filenames that
do not match strings 1–6 and a nonnegative fret, and needs at least one
matching file. `data/` and `models/` are ignored by Git, so recordings and
trained models are local artifacts.

The classifier converts those names to standard-tuning pitches:

- string 6: E2
- string 5: A2
- string 4: D3
- string 3: G3
- string 2: B3
- string 1: E4

The fret number is added to the open-string MIDI number. Targets are `note`
(default, for example `E2`), `midi` (`40`), `pitch-class` (`E`), and
`string-fret` (`6-0`); choose one with `--target` on `scan` or `train`.
The WAV reader accepts 8-, 16-, 24-, and 32-bit integer PCM, mixes channels
to mono, skips 0.15 seconds, reads up to one second, and uses integer
decimation with a default `--max-rate` setting of 8 kHz. That setting is not
a strict output-rate ceiling. Use `--start`, `--duration`, and `--max-rate` on
training and prediction to adjust the analysis window.

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

Training evaluates on a seeded, per-label holdout (default 20%), then fits
all examples and saves the model. A label with only one recording stays in
training and does not appear in the holdout score. The defaults are five
neighbors, seed 13, and `models/clean_pitch_knn.json`. Training overwrites
that model file; use a distinct `--model` path for each target if you train
multiple label types.

Predict one or more WAV files:

```bash
uv run pedal predict data/clean/Bridge/6-0.wav
```

Run `train` first; `predict` and `benchmark` load the saved model by default.
Prediction prints the model label, estimated frequency and note, pitch
confidence, and neighbor vote counts. Use `--model` to load another model.

Benchmark classification latency:

```bash
uv run pedal benchmark
```

The benchmark reports classifier-only, feature-extraction plus classifier,
and overlapping-frame feature-extraction plus classifier latency. By default,
it uses up to eight dataset files, five warmup calls, and 100 timed iterations.
It reports mean, median, p95, and maximum latency. The CLI checks p95 under
30 ms for classifier computation. The product's immediate minimum acceptable
latency target is 30 ms; the long-term goal is 10 ms. The streaming-frame path
uses preloaded WAV
segments with 64 ms frames and a 32 ms hop. It measures computation, not ALSA
input/output delay or real-time frame scheduling, so it cannot establish either
product latency target by itself. Add `--include-io` to measure
WAV reading in a separate path, or pass WAV paths directly to benchmark.

```bash
uv run pedal benchmark --stream-frame 0.064 --stream-hop 0.032
```

The default trained model is written to `models/clean_pitch_knn.json`.

Inside the interactive CLI, use `help` to list commands. The core commands are
`scan`, `train`, `predict <wav>`, `benchmark [iterations]`, `settings`, and
`quit`. You can change `data`, `model`, `target`, `k`, `start`, `duration`,
and `max-rate` in that shell. Use Ctrl+D to leave it.

For the full option list of an offline command, run `uv run pedal train --help`
(or replace `train` with `scan`, `predict`, or `benchmark`).

## Troubleshooting

- **No ALSA capture/playback device:** check `uv run pedal effect --list-devices`
  and `arecord -l`; pass the correct `plughw` names explicitly.
- **`/run/guitar-effect.sock` permission error:** the effect cannot create its
  control socket. Give the effect account access to this fixed path and use a
  control/UI account with socket access.
- **`pedal effect is not running`:** start the effect first, then run `mode`
  on the same machine and check socket permissions.
- **No labeled WAVs or missing model:** verify the dataset layout with `scan`,
  then run `train` before `predict` or `benchmark`.
- **Audio breakup:** increase `--block` to 256 or 512 and use `--meter` to
  inspect ALSA recovery counts.

## Tests

```bash
uv run python -m unittest discover -s tests
```

The tests cover audio and feature extraction, model behavior, effect
processing, local mode control, and CLI defaults. They do not exercise physical
ALSA, GPIO, MIDI, or browser hardware paths. See
[the architecture guide](docs/dev/architecture.md) for the module and data-flow
map. The [agile plan](docs/agile/README.md) links the current planning
spreadsheets and explains their limits.
