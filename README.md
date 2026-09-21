# ML Guitar Pedal

Prototype tooling for a future ML-based guitar pedal. The first milestone is a
pitch classifier for the labeled clean-tone recordings under `data/clean/`.

## Setup

```bash
uv sync
```

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

Classify the live guitar signal from an iRig on Linux with PipeWire:

```bash
uv run pedal live
```

This automatically selects the connected iRig input and uses the saved model.
Play one clean note at a time; the terminal prints the predicted label, frequency,
input level in dBFS, and YIN pitch confidence. Silence is shown as `quiet` and
unreliable pitch as `uncertain`. Press Ctrl+C to stop. This is a single-note
classifier, not a chord detector. Pitch confidence is not a calibrated probability
that the model's label is correct.

Requires the system commands `pw-record` and `pactl`. Audio is processed in memory
using 64 ms frames with a 32 ms hop, resampled by PipeWire to 8 kHz.
The existing model was trained on longer WAV segments; live accuracy may differ.
Use the iRig gain knob to avoid clipping. For a weak signal, lower the silence gate:

```bash
uv run pedal live --gate-db -60
uv run pedal live --list-devices
uv run pedal live --device 'iRig HD 2' --seconds 10
```

The interactive shell also accepts `live` and the same options.

Open the Tkinter live note graph:

```bash
uv run pedal gui
```

Select your iRig input and press **Start**. The window shows the classifier's
current label, signal level, pitch confidence, and a scrolling 15-second graph
of estimated pitch from E2 to E6. Silence and uncertain pitch leave gaps. Use
**Stop** to release the input, or close the window. Set the silence gate and
confidence threshold before starting. **Clear graph** clears the displayed history.
Tkinter must be installed for the Python interpreter; no plotting package is needed.
Use `--model PATH` to select another saved classifier.

Classify a clean signal and print a matching file from `data/blues-driver/`:

```bash
uv run pedal-demo data/clean/Bridge/6-0.wav
```

The demo uses the saved note classifier in `models/clean_pitch_knn.json`.
If that model is missing, first run `uv run pedal train`. A note can have
several string and fret positions; the demo prefers the clean input's pickup
folder and then the lowest fret. Use `--model` and `--blues-dir` to change
those paths.

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
