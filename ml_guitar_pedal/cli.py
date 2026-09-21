from __future__ import annotations

import argparse
import shlex
import time
from collections import Counter
from dataclasses import dataclass
from itertools import cycle
from pathlib import Path
from statistics import mean, median

from tqdm import tqdm

from ml_guitar_pedal.audio import AudioSignal, read_wav_mono
from ml_guitar_pedal.dataset import ToneSample, midi_to_note, note_summary, scan_clean_tones
from ml_guitar_pedal.features import ExtractedFeatures, extract_features
from ml_guitar_pedal.model import (
    KnnPitchClassifier,
    TrainingExample,
    accuracy,
    load_model,
    save_model,
    train_test_split,
)
from ml_guitar_pedal.streaming import frames_from_signal
from ml_guitar_pedal.live import live_command

TARGETS = ("note", "midi", "pitch-class", "string-fret")
DEFAULT_DATA_PATH = Path("data/clean")
DEFAULT_MODEL_PATH = Path("models/clean_pitch_knn.json")
DEFAULT_START_SECONDS = 0.15
DEFAULT_DURATION_SECONDS = 1.0
DEFAULT_MAX_SAMPLE_RATE = 8_000
DEFAULT_K = 5
DEFAULT_TEST_SIZE = 0.2
DEFAULT_SEED = 13
DEFAULT_BENCHMARK_ITERATIONS = 100
DEFAULT_BENCHMARK_LIMIT = 8
DEFAULT_STREAM_FRAME_SECONDS = 0.064
DEFAULT_STREAM_HOP_SECONDS = 0.032
RASPBERRY_PI_TARGET_MS = 30.0


def main() -> None:
    parser = build_parser()
    args = parser.parse_args()
    if hasattr(args, "func"):
        args.func(args)
    else:
        interactive_command(
            argparse.Namespace(
                data=DEFAULT_DATA_PATH,
                model=DEFAULT_MODEL_PATH,
                start=DEFAULT_START_SECONDS,
                duration=DEFAULT_DURATION_SECONDS,
                max_rate=DEFAULT_MAX_SAMPLE_RATE,
            )
        )


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Pitch classifier tools for clean guitar tone WAVs.")
    subparsers = parser.add_subparsers(dest="command")

    scan_parser = subparsers.add_parser("scan", help="Summarize the clean tone dataset.")
    scan_parser.add_argument("--data", type=Path, default=DEFAULT_DATA_PATH)
    scan_parser.add_argument("--target", choices=TARGETS, default="note")
    scan_parser.set_defaults(func=scan_command)

    train_parser = subparsers.add_parser("train", help="Train and evaluate a KNN pitch classifier.")
    train_parser.add_argument("--data", type=Path, default=DEFAULT_DATA_PATH)
    train_parser.add_argument("--model", type=Path, default=DEFAULT_MODEL_PATH)
    train_parser.add_argument("--target", choices=TARGETS, default="note")
    train_parser.add_argument("--k", type=int, default=DEFAULT_K)
    train_parser.add_argument("--test-size", type=float, default=DEFAULT_TEST_SIZE)
    train_parser.add_argument("--seed", type=int, default=DEFAULT_SEED)
    train_parser.add_argument("--start", type=float, default=DEFAULT_START_SECONDS, help="Seconds to skip at the start of each WAV.")
    train_parser.add_argument("--duration", type=float, default=DEFAULT_DURATION_SECONDS, help="Seconds of audio to analyze.")
    train_parser.add_argument("--max-rate", type=int, default=DEFAULT_MAX_SAMPLE_RATE, help="Maximum sample rate used for features.")
    train_parser.set_defaults(func=train_command)

    predict_parser = subparsers.add_parser("predict", help="Predict pitch labels for one or more WAV files.")
    predict_parser.add_argument("paths", type=Path, nargs="+")
    predict_parser.add_argument("--model", type=Path, default=DEFAULT_MODEL_PATH)
    predict_parser.add_argument("--start", type=float, default=DEFAULT_START_SECONDS)
    predict_parser.add_argument("--duration", type=float, default=DEFAULT_DURATION_SECONDS)
    predict_parser.add_argument("--max-rate", type=int, default=DEFAULT_MAX_SAMPLE_RATE)
    predict_parser.set_defaults(func=predict_command)

    live_parser = subparsers.add_parser("live", help="Classify live guitar input using PipeWire (Linux).")
    live_parser.add_argument("--model", type=Path, default=DEFAULT_MODEL_PATH)
    live_parser.add_argument("--device", help="Input name or description; defaults to the connected iRig.")
    live_parser.add_argument("--list-devices", action="store_true")
    live_parser.add_argument("--seconds", type=float, default=0, help="Stop after this many seconds; 0 runs until Ctrl+C.")
    live_parser.add_argument("--gate-db", type=float, default=-50, help="Minimum signal RMS in dBFS.")
    live_parser.add_argument("--min-confidence", type=float, default=0.8, help="Minimum YIN pitch confidence (0..1).")
    live_parser.set_defaults(func=live_command)

    gui_parser = subparsers.add_parser("gui", help="Open the live note graph in Tkinter.")
    gui_parser.add_argument("--model", type=Path, default=DEFAULT_MODEL_PATH)
    gui_parser.set_defaults(func=gui_command)

    interactive_parser = subparsers.add_parser("interactive", help="Open an interactive pitch-classifier shell.")
    interactive_parser.add_argument("--data", type=Path, default=DEFAULT_DATA_PATH)
    interactive_parser.add_argument("--model", type=Path, default=DEFAULT_MODEL_PATH)
    interactive_parser.add_argument("--start", type=float, default=DEFAULT_START_SECONDS)
    interactive_parser.add_argument("--duration", type=float, default=DEFAULT_DURATION_SECONDS)
    interactive_parser.add_argument("--max-rate", type=int, default=DEFAULT_MAX_SAMPLE_RATE)
    interactive_parser.set_defaults(func=interactive_command)

    benchmark_parser = subparsers.add_parser("benchmark", help="Measure pitch-classification latency.")
    benchmark_parser.add_argument("paths", type=Path, nargs="*", help="Optional WAV files to benchmark.")
    benchmark_parser.add_argument("--data", type=Path, default=DEFAULT_DATA_PATH)
    benchmark_parser.add_argument("--model", type=Path, default=DEFAULT_MODEL_PATH)
    benchmark_parser.add_argument("--iterations", type=int, default=DEFAULT_BENCHMARK_ITERATIONS)
    benchmark_parser.add_argument("--warmup", type=int, default=5)
    benchmark_parser.add_argument("--limit", type=int, default=DEFAULT_BENCHMARK_LIMIT, help="Dataset files to cycle through when no paths are given.")
    benchmark_parser.add_argument("--include-io", action="store_true", help="Also benchmark WAV read + feature extraction + classifier.")
    benchmark_parser.add_argument("--start", type=float, default=DEFAULT_START_SECONDS)
    benchmark_parser.add_argument("--duration", type=float, default=DEFAULT_DURATION_SECONDS)
    benchmark_parser.add_argument("--max-rate", type=int, default=DEFAULT_MAX_SAMPLE_RATE)
    benchmark_parser.add_argument("--stream-frame", type=float, default=DEFAULT_STREAM_FRAME_SECONDS, help="Streaming frame size in seconds.")
    benchmark_parser.add_argument("--stream-hop", type=float, default=DEFAULT_STREAM_HOP_SECONDS, help="Streaming hop size in seconds.")
    benchmark_parser.set_defaults(func=benchmark_command)

    return parser


def gui_command(args: argparse.Namespace) -> None:
    from ml_guitar_pedal.gui import launch
    launch(args.model)


def scan_command(args: argparse.Namespace) -> None:
    samples = scan_clean_tones(args.data)
    pickups = Counter(sample.pickup for sample in samples)
    labels = note_summary(samples, target=args.target)

    print(f"files: {len(samples)}")
    print(f"pickups: {', '.join(f'{pickup}={count}' for pickup, count in sorted(pickups.items()))}")
    print(f"{args.target} labels: {len(labels)}")
    lowest_note = midi_to_note(min(sample.midi for sample in samples))
    highest_note = midi_to_note(max(sample.midi for sample in samples))
    print(f"range: {lowest_note}..{highest_note}")


def train_command(args: argparse.Namespace) -> None:
    samples = scan_clean_tones(args.data)
    examples = [
        example_from_sample(
            sample,
            target=args.target,
            start=args.start,
            duration=args.duration,
            max_rate=args.max_rate,
        )
        for sample in tqdm(samples, desc="extracting features", unit="file")
    ]

    train_examples, test_examples = train_test_split(examples, test_size=args.test_size, seed=args.seed)
    classifier = KnnPitchClassifier(k=args.k)
    classifier.fit(train_examples)
    correct, total, score = accuracy(classifier, test_examples)

    full_classifier = KnnPitchClassifier(k=args.k)
    full_classifier.fit(examples)
    save_model(full_classifier, args.model)

    print(f"dataset: {len(samples)} files from {args.data}")
    print(f"target: {args.target}")
    print(f"holdout accuracy: {correct}/{total} ({score:.1%})")
    print(f"saved model: {args.model}")
    _print_confusion(classifier, test_examples)


def predict_command(args: argparse.Namespace) -> None:
    classifier = load_model(args.model)
    for path in args.paths:
        print(predict_path(classifier, path, start=args.start, duration=args.duration, max_rate=args.max_rate))


def benchmark_command(args: argparse.Namespace) -> None:
    if args.iterations < 1:
        raise ValueError("iterations must be at least 1")
    if args.warmup < 0:
        raise ValueError("warmup must not be negative")

    classifier = load_model(args.model)
    paths = list(args.paths) if args.paths else benchmark_paths_from_dataset(args.data, limit=args.limit)
    samples = [
        prepare_benchmark_sample(path, start=args.start, duration=args.duration, max_rate=args.max_rate)
        for path in tqdm(paths, desc="preparing benchmark samples", unit="file")
    ]
    streaming_samples = prepare_streaming_benchmark_samples(
        samples,
        frame_seconds=args.stream_frame,
        hop_seconds=args.stream_hop,
    )

    print(f"benchmark samples: {len(samples)}")
    print(
        f"streaming frames: {len(streaming_samples)} "
        f"({args.stream_frame * 1_000:.0f} ms frame / {args.stream_hop * 1_000:.0f} ms hop)"
    )
    print(f"iterations: {args.iterations} warmup: {args.warmup}")
    print(f"raspberry pi target: <{RASPBERRY_PI_TARGET_MS:.0f} ms per classification")

    feature_latencies = measure_latency(
        description="feature + classifier",
        iterations=args.iterations,
        warmup=args.warmup,
        items=samples,
        operation=lambda sample: classifier.predict(extract_features(sample.signal).values),
    )
    print_latency_summary("feature + classifier", feature_latencies, target_ms=RASPBERRY_PI_TARGET_MS)

    streaming_latencies = measure_latency(
        description="streaming frame + classifier",
        iterations=args.iterations,
        warmup=args.warmup,
        items=streaming_samples,
        operation=lambda sample: classifier.predict(extract_features(sample.signal).values),
    )
    print_latency_summary("streaming frame + classifier", streaming_latencies, target_ms=RASPBERRY_PI_TARGET_MS)

    classifier_latencies = measure_latency(
        description="classifier only",
        iterations=args.iterations,
        warmup=args.warmup,
        items=samples,
        operation=lambda sample: classifier.predict(sample.features.values),
    )
    print_latency_summary("classifier only", classifier_latencies)

    if args.include_io:
        io_latencies = measure_latency(
            description="wav read + feature + classifier",
            iterations=args.iterations,
            warmup=args.warmup,
            items=paths,
            operation=lambda path: predict_path(
                classifier,
                path,
                start=args.start,
                duration=args.duration,
                max_rate=args.max_rate,
            ),
        )
        print_latency_summary("wav read + feature + classifier", io_latencies, target_ms=RASPBERRY_PI_TARGET_MS)


def interactive_command(args: argparse.Namespace) -> None:
    state = InteractiveState(
        data=args.data,
        model=args.model,
        start=args.start,
        duration=args.duration,
        max_rate=args.max_rate,
    )
    print("ML guitar pedal interactive CLI")
    print("Type help for commands, or quit to exit.")

    while True:
        try:
            raw_command = input("pedal> ").strip()
        except EOFError:
            print()
            return

        if not raw_command:
            continue
        if raw_command in {"quit", "exit", "q"}:
            print("bye")
            return

        try:
            handle_interactive_command(raw_command, state)
        except (FileNotFoundError, ValueError) as error:
            print(f"error: {error}")


class InteractiveState:
    def __init__(
        self,
        *,
        data: Path,
        model: Path,
        start: float,
        duration: float,
        max_rate: int,
    ) -> None:
        self.data = data
        self.model = model
        self.start = start
        self.duration = duration
        self.max_rate = max_rate
        self.target = "note"
        self.k = DEFAULT_K
        self.test_size = DEFAULT_TEST_SIZE
        self.seed = DEFAULT_SEED


def handle_interactive_command(raw_command: str, state: InteractiveState) -> None:
    tokens = shlex.split(raw_command)
    if not tokens:
        return

    command, *args = tokens
    if command == "help":
        print_interactive_help()
    elif command == "settings":
        print_interactive_settings(state)
    elif command == "gui":
        gui_command(argparse.Namespace(model=state.model))
    elif command == "live":
        live_args = build_parser().parse_args(["live", "--model", str(state.model), *args])
        live_args.command = "interactive"
        live_command(live_args)
    elif command == "scan":
        scan_command(argparse.Namespace(data=state.data, target=state.target))
    elif command == "train":
        train_command(
            argparse.Namespace(
                data=state.data,
                model=state.model,
                target=state.target,
                k=state.k,
                test_size=state.test_size,
                seed=state.seed,
                start=state.start,
                duration=state.duration,
                max_rate=state.max_rate,
            )
        )
    elif command == "predict":
        if not args:
            raise ValueError("predict needs at least one WAV path")
        predict_command(
            argparse.Namespace(
                paths=[Path(path) for path in args],
                model=state.model,
                start=state.start,
                duration=state.duration,
                max_rate=state.max_rate,
            )
        )
    elif command == "benchmark":
        iterations = int(args[0]) if args else DEFAULT_BENCHMARK_ITERATIONS
        benchmark_command(
            argparse.Namespace(
                paths=[],
                data=state.data,
                model=state.model,
                iterations=iterations,
                warmup=5,
                limit=DEFAULT_BENCHMARK_LIMIT,
                include_io=False,
                start=state.start,
                duration=state.duration,
                max_rate=state.max_rate,
                stream_frame=DEFAULT_STREAM_FRAME_SECONDS,
                stream_hop=DEFAULT_STREAM_HOP_SECONDS,
            )
        )
    elif command in {"data", "model", "target", "k", "start", "duration", "max-rate"}:
        update_interactive_setting(command, args, state)
    else:
        raise ValueError(f"unknown command: {command}")


def update_interactive_setting(command: str, args: list[str], state: InteractiveState) -> None:
    if len(args) != 1:
        raise ValueError(f"{command} needs exactly one value")

    value = args[0]
    if command == "data":
        state.data = Path(value)
    elif command == "model":
        state.model = Path(value)
    elif command == "target":
        if value not in TARGETS:
            raise ValueError(f"target must be one of: {', '.join(TARGETS)}")
        state.target = value
    elif command == "k":
        state.k = int(value)
        if state.k < 1:
            raise ValueError("k must be at least 1")
    elif command == "start":
        state.start = float(value)
    elif command == "duration":
        state.duration = float(value)
    elif command == "max-rate":
        state.max_rate = int(value)
    print_interactive_settings(state)


def print_interactive_help() -> None:
    print("commands:")
    print("  settings")
    print("  scan")
    print("  train")
    print("  predict <wav> [wav ...]")
    print("  live [--list-devices | --device NAME] [--gate-db -50]")
    print("  gui")
    print("  benchmark [iterations]")
    print("  data <path>")
    print("  model <path>")
    print(f"  target <{'|'.join(TARGETS)}>")
    print("  k <neighbors>")
    print("  start <seconds>")
    print("  duration <seconds>")
    print("  max-rate <hz>")
    print("  quit")


def print_interactive_settings(state: InteractiveState) -> None:
    print(f"data: {state.data}")
    print(f"model: {state.model}")
    print(f"target: {state.target}")
    print(f"k: {state.k}")
    print(f"analysis: start={state.start}s duration={state.duration}s max-rate={state.max_rate}Hz")


def predict_path(
    classifier: KnnPitchClassifier,
    path: Path,
    *,
    start: float,
    duration: float,
    max_rate: int,
) -> str:
    signal = read_wav_mono(
        path,
        start_seconds=start,
        duration_seconds=duration,
        max_sample_rate=max_rate,
    )
    features = extract_features(signal)
    prediction = classifier.predict(features.values)
    estimated_note = midi_to_note(features.estimated_note_midi)
    vote_text = ", ".join(f"{label}:{count}" for label, count in prediction.votes)
    return (
        f"{path}: {prediction.label} "
        f"(estimated {features.estimated_hz:.1f} Hz / {estimated_note}, "
        f"confidence {features.confidence:.2f}, votes {vote_text})"
    )


@dataclass(frozen=True)
class BenchmarkSample:
    path: Path
    signal: AudioSignal
    features: ExtractedFeatures


def benchmark_paths_from_dataset(data: Path, *, limit: int) -> list[Path]:
    if limit < 1:
        raise ValueError("limit must be at least 1")

    samples = scan_clean_tones(data)
    if limit >= len(samples):
        return [sample.path for sample in samples]

    step = len(samples) / limit
    return [samples[int(index * step)].path for index in range(limit)]


def prepare_benchmark_sample(
    path: Path,
    *,
    start: float,
    duration: float,
    max_rate: int,
) -> BenchmarkSample:
    signal = read_wav_mono(
        path,
        start_seconds=start,
        duration_seconds=duration,
        max_sample_rate=max_rate,
    )
    return BenchmarkSample(path=path, signal=signal, features=extract_features(signal))


def prepare_streaming_benchmark_samples(
    samples: list[BenchmarkSample],
    *,
    frame_seconds: float,
    hop_seconds: float,
) -> list[BenchmarkSample]:
    stream_samples: list[BenchmarkSample] = []
    for sample in samples:
        for frame in frames_from_signal(
            sample.signal,
            frame_seconds=frame_seconds,
            hop_seconds=hop_seconds,
        ):
            stream_samples.append(
                BenchmarkSample(
                    path=sample.path,
                    signal=frame.signal,
                    features=extract_features(frame.signal),
                )
            )

    if not stream_samples:
        raise ValueError("streaming benchmark did not produce any frames")
    return stream_samples


def measure_latency(
    *,
    description: str,
    iterations: int,
    warmup: int,
    items: list,
    operation,
) -> list[float]:
    if not items:
        raise ValueError("benchmark needs at least one item")

    item_cycle = cycle(items)
    for _ in range(warmup):
        operation(next(item_cycle))

    latencies_ms: list[float] = []
    for _ in tqdm(range(iterations), desc=description, unit="run"):
        item = next(item_cycle)
        started_at = time.perf_counter()
        operation(item)
        latencies_ms.append((time.perf_counter() - started_at) * 1_000.0)
    return latencies_ms


def print_latency_summary(name: str, latencies_ms: list[float], *, target_ms: float | None = None) -> None:
    p95 = percentile(latencies_ms, 95.0)
    print(
        f"{name}: mean={mean(latencies_ms):.2f} ms "
        f"p50={median(latencies_ms):.2f} ms "
        f"p95={p95:.2f} ms "
        f"max={max(latencies_ms):.2f} ms"
    )
    if target_ms is not None:
        status = "PASS" if p95 < target_ms else "MISS"
        print(f"{name} target check: {status} p95<{target_ms:.0f}ms")


def percentile(values: list[float], percentile_value: float) -> float:
    if not values:
        raise ValueError("Cannot compute a percentile without values")
    ordered = sorted(values)
    rank = (len(ordered) - 1) * (percentile_value / 100.0)
    lower = int(rank)
    upper = min(lower + 1, len(ordered) - 1)
    fraction = rank - lower
    return ordered[lower] + (ordered[upper] - ordered[lower]) * fraction


def example_from_sample(
    sample: ToneSample,
    *,
    target: str,
    start: float,
    duration: float,
    max_rate: int,
) -> TrainingExample:
    signal = read_wav_mono(
        sample.path,
        start_seconds=start,
        duration_seconds=duration,
        max_sample_rate=max_rate,
    )
    features = extract_features(signal)
    return TrainingExample(
        label=sample.label_for(target),
        features=features.values,
        path=str(sample.path),
        pickup=sample.pickup,
        note=sample.note,
        midi=sample.midi,
        string=sample.string,
        fret=sample.fret,
    )


def _print_confusion(classifier: KnnPitchClassifier, examples: list[TrainingExample]) -> None:
    mistakes = Counter()
    for example in examples:
        predicted = classifier.predict(example.features).label
        if predicted != example.label:
            mistakes[(example.label, predicted)] += 1

    if not mistakes:
        print("confusion: none")
        return

    print("top confusion:")
    for (actual, predicted), count in mistakes.most_common(8):
        print(f"  {actual} -> {predicted}: {count}")


if __name__ == "__main__":
    main()
