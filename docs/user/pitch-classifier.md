# Offline pitch classifier

This workflow classifies WAV recordings. It does not process live audio and its model is not loaded by `pedal effect`.

## Prepare recordings

Place files one folder below the data root, using `data/clean/<pickup>/<string>-<fret>.wav`. For example, `data/clean/Bridge/6-0.wav` is the open sixth string recorded with the Bridge pickup. The scan accepts string numbers 1–6 and nonnegative integer fret numbers; files outside that layout are skipped. It needs at least one matching WAV.

| String | Open note | MIDI number |
| --- | --- | ---: |
| 6 | E2 | 40 |
| 5 | A2 | 45 |
| 4 | D3 | 50 |
| 3 | G3 | 55 |
| 2 | B3 | 59 |
| 1 | E4 | 64 |

Labels assume standard tuning; the fret number is added to the open-string MIDI number. The WAV reader supports 8-, 16-, 24-, and 32-bit integer PCM. By default it skips 0.15 seconds, reads up to one second, mixes channels to mono, and uses integer decimation with an 8 kHz `--max-rate` setting. The effective rate can exceed that setting because the stride is an integer.

## Scan, train, and predict

```bash
uv run pedal scan --data data/clean
uv run pedal train --data data/clean --model models/clean_pitch_knn.json
uv run pedal predict data/clean/Bridge/6-0.wav
```

`scan` reports file, pickup, label, and note-range counts. `train` extracts features and evaluates a seeded per-label holdout before fitting all examples and saving the JSON model. The defaults are five neighbors, a 20% holdout, seed 13, and target `note`. A label represented by one recording remains in training and does not contribute to holdout accuracy.

Choose `--target note`, `midi`, `pitch-class`, or `string-fret` for training. The default model file is overwritten each time, so use a different `--model` path for each target. Prediction loads the model and prints its label, estimated frequency and note, confidence, and neighbor vote counts. It requires a trained model first.

Use `--start`, `--duration`, and `--max-rate` to change the WAV analysis window for `train` or `predict`. Keep these settings consistent when comparing a new recording with the training data. Run `uv run pedal train --help` for all training options.

## Benchmark

```bash
uv run pedal benchmark
uv run pedal benchmark data/clean/Bridge/6-0.wav --iterations 50 --include-io
```

Without paths, the benchmark uses up to eight dataset files. Defaults are five warmup calls, 100 timed iterations, a 64 ms overlapping frame, and a 32 ms hop. It reports classifier-only, feature-plus-classifier, and frame feature-plus-classifier times. `--include-io` adds a separate WAV-read path. The CLI checks p95 under 30 ms for classifier computation. The product's immediate minimum acceptable latency target is 30 ms, with 10 ms as the long-term goal. These benchmark numbers measure computation on prepared WAV content, not full live audio latency.

## Interactive shell

Run `uv run pedal` or `uv run pedal interactive`; type `help` to list commands. The shell supports `scan`, `train`, `predict <wav>`, `benchmark [iterations]`, `settings`, and setters for `data`, `model`, `target`, `k`, `start`, `duration`, and `max-rate`. Type `quit` or press Ctrl+D to exit.
