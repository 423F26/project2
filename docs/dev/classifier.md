# Classifier internals

## Data and features

`dataset.scan_clean_tones()` reads `*/*.wav` below the data root and accepts filenames matching `<string>-<fret>.wav` for strings 1–6 and a nonnegative integer fret. The parent folder is the pickup name. It derives MIDI and note labels from standard tuning. The selectable targets are `note`, `midi`, `pitch-class`, and `string-fret`.

`audio.read_wav_mono()` reads an integer-PCM WAV segment, averages channels, removes DC offset, and decimates by an integer stride. The CLI defaults to a 0.15 second start, one second of audio, and `--max-rate 8000`. This value controls the stride calculation; it is not a strict output-rate ceiling. For example, 44,100 Hz divided by a stride of five yields 8,820 Hz.

`features.extract_features()` estimates fundamental frequency with a YIN-style difference function, applies an even-harmonic octave correction, then emits ten features: estimated MIDI value, cents offset, YIN confidence, log RMS, zero-crossing rate, crest factor, and four harmonic log-power values. The default pitch search is 60–1,400 Hz. Very short or empty signals can fail extraction.

## Training and model file

`train_test_split()` shuffles per label with seed 13 by default and holds out approximately 20% of labels with multiple examples. A singleton label stays in training. The CLI prints holdout accuracy, then fits a second classifier on every example and saves that full model to JSON. Do not interpret a holdout score as proof of performance for singleton labels or for a different pickup/recording setup.

`KnnPitchClassifier` standardizes features, applies weights, narrows candidates through per-label prototypes, and uses inverse-distance voting among up to `k` nearest examples. The default `k` is five. The JSON stores feature names, normalization values, prototypes, and examples. Loading checks feature names against the running code; after changing the feature schema or meaning, retrain and validate saved models. The CLI does not store the selected target as a dedicated model field, so use distinct filenames and document which target each model represents.

## Benchmark interpretation

`benchmark` preloads up to eight WAV files unless paths are supplied. It prepares full signals and overlapping frames before timing. The timed paths cover full-signal feature extraction plus prediction, frame feature extraction plus prediction, and classifier-only prediction. `--include-io` adds a separate WAV-read, feature, and prediction measurement. Defaults are 100 iterations, five warmup calls, 64 ms frames, and 32 ms hops.

The CLI prints a p95-below-30-ms check for classifier computation. It does not test ALSA capture/playback, real-time scheduling, or total input-to-output delay. The product's immediate minimum acceptable latency target is 30 ms and the long-term goal is 10 ms. Their measurement method still needs to be defined; see the [agile plan](../agile/README.md).
