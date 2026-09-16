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
