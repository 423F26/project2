from __future__ import annotations

import contextlib
import io
import math
import tempfile
import unittest
import wave
from pathlib import Path

from ml_guitar_pedal.audio import read_wav_mono
from ml_guitar_pedal.cli import InteractiveState, build_parser, handle_interactive_command
from ml_guitar_pedal.dataset import midi_to_note
from ml_guitar_pedal.features import correct_octave_from_even_harmonics, extract_features
from ml_guitar_pedal.model import KnnPitchClassifier, TrainingExample
from ml_guitar_pedal.streaming import StreamingFrameBuffer


class PitchClassifierTests(unittest.TestCase):
    def test_midi_to_note_uses_standard_guitar_reference_points(self) -> None:
        self.assertEqual(midi_to_note(40), "E2")
        self.assertEqual(midi_to_note(45), "A2")
        self.assertEqual(midi_to_note(64), "E4")

    def test_reads_24_bit_wav_and_estimates_pitch(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            wav_path = Path(temp_dir) / "a4.wav"
            _write_sine_24_bit(wav_path, frequency=440.0)

            signal = read_wav_mono(wav_path, start_seconds=0.0, duration_seconds=0.5)
            features = extract_features(signal)

        self.assertAlmostEqual(features.estimated_hz, 440.0, delta=3.0)
        self.assertEqual(features.estimated_note_midi, 69)

    def test_even_harmonic_octave_trap_is_corrected(self) -> None:
        sample_rate = 8_000
        samples = _sine_mix(
            sample_rate=sample_rate,
            frequencies=(294.0, 588.0, 882.0, 1176.0),
            amplitudes=(0.02, 1.0, 0.02, 0.8),
        )

        corrected = correct_octave_from_even_harmonics(samples, sample_rate, 294.0)

        self.assertAlmostEqual(corrected, 588.0)

    def test_balanced_harmonics_do_not_trigger_octave_correction(self) -> None:
        sample_rate = 8_000
        samples = _sine_mix(
            sample_rate=sample_rate,
            frequencies=(294.0, 588.0, 882.0, 1176.0),
            amplitudes=(1.0, 0.35, 0.2, 0.1),
        )

        corrected = correct_octave_from_even_harmonics(samples, sample_rate, 294.0)

        self.assertAlmostEqual(corrected, 294.0)

    def test_knn_classifier_predicts_nearest_training_label(self) -> None:
        classifier = KnnPitchClassifier(k=1)
        classifier.fit(
            [
                _example("E2", 40.0),
                _example("A2", 45.0),
            ]
        )

        prediction = classifier.predict((44.8, 0.0, 0.9, -3.0, 0.1, 2.0, -1.0, -2.0, -3.0, -4.0))

        self.assertEqual(prediction.label, "A2")

    def test_knn_uses_distance_weighted_votes(self) -> None:
        classifier = KnnPitchClassifier(k=3)
        classifier.fit(
            [
                _example("A2", 45.0),
                _example("E4", 64.0),
                _example("E4", 65.0),
            ]
        )

        prediction = classifier.predict((45.1, 0.0, 0.9, -3.0, 0.1, 2.0, -1.0, -2.0, -3.0, -4.0))

        self.assertEqual(prediction.label, "A2")

    def test_knn_builds_label_prototypes_for_candidate_search(self) -> None:
        classifier = KnnPitchClassifier(k=1)
        classifier.fit(
            [
                _example("A2", 45.0),
                _example("A2", 45.1),
                _example("E4", 64.0),
                _example("E4", 64.1),
            ]
        )

        self.assertEqual(len(classifier.prototypes), 2)
        self.assertEqual(sorted(prototype.label for prototype in classifier.prototypes), ["A2", "E4"])
        self.assertEqual(sum(prototype.count for prototype in classifier.prototypes), 4)

    def test_interactive_parser_uses_project_defaults(self) -> None:
        args = build_parser().parse_args(["interactive"])

        self.assertEqual(args.data, Path("data/clean"))
        self.assertEqual(args.model, Path("models/clean_pitch_knn.json"))

    def test_benchmark_parser_uses_project_defaults(self) -> None:
        args = build_parser().parse_args(["benchmark"])

        self.assertEqual(args.data, Path("data/clean"))
        self.assertEqual(args.model, Path("models/clean_pitch_knn.json"))
        self.assertEqual(args.iterations, 100)
        self.assertEqual(args.limit, 8)
        self.assertAlmostEqual(args.stream_frame, 0.064)
        self.assertAlmostEqual(args.stream_hop, 0.032)
        self.assertFalse(args.include_io)

    def test_streaming_frame_buffer_emits_overlapping_frames(self) -> None:
        buffer = StreamingFrameBuffer(sample_rate=1_000, frame_seconds=0.004, hop_seconds=0.002)

        first_frames = buffer.push([0.0, 1.0, 2.0])
        second_frames = buffer.push([3.0, 4.0, 5.0])

        self.assertEqual(first_frames, [])
        self.assertEqual(len(second_frames), 2)
        self.assertEqual(second_frames[0].signal.samples, (0.0, 1.0, 2.0, 3.0))
        self.assertEqual(second_frames[1].signal.samples, (2.0, 3.0, 4.0, 5.0))
        self.assertAlmostEqual(second_frames[1].offset_seconds, 0.002)

    def test_interactive_settings_update_state(self) -> None:
        state = InteractiveState(
            data=Path("data/clean"),
            model=Path("models/clean_pitch_knn.json"),
            start=0.15,
            duration=1.0,
            max_rate=8_000,
        )

        with contextlib.redirect_stdout(io.StringIO()):
            handle_interactive_command("target pitch-class", state)
            handle_interactive_command("k 3", state)
            handle_interactive_command("data data/other-clean", state)

        self.assertEqual(state.target, "pitch-class")
        self.assertEqual(state.k, 3)
        self.assertEqual(state.data, Path("data/other-clean"))

    def test_interactive_settings_reject_unknown_target(self) -> None:
        state = InteractiveState(
            data=Path("data/clean"),
            model=Path("models/clean_pitch_knn.json"),
            start=0.15,
            duration=1.0,
            max_rate=8_000,
        )

        with self.assertRaises(ValueError):
            handle_interactive_command("target chord", state)


def _write_sine_24_bit(path: Path, *, frequency: float, sample_rate: int = 48_000) -> None:
    duration_seconds = 0.75
    frames = bytearray()
    for index in range(int(sample_rate * duration_seconds)):
        value = int(0.4 * ((1 << 23) - 1) * math.sin(2.0 * math.pi * frequency * index / sample_rate))
        frames.extend(value.to_bytes(3, byteorder="little", signed=True))

    with wave.open(str(path), "wb") as wav_file:
        wav_file.setnchannels(1)
        wav_file.setsampwidth(3)
        wav_file.setframerate(sample_rate)
        wav_file.writeframes(bytes(frames))


def _sine_mix(
    *,
    sample_rate: int,
    frequencies: tuple[float, ...],
    amplitudes: tuple[float, ...],
    duration_seconds: float = 0.5,
) -> tuple[float, ...]:
    samples = []
    for index in range(int(sample_rate * duration_seconds)):
        sample = 0.0
        for frequency, amplitude in zip(frequencies, amplitudes):
            sample += amplitude * math.sin(2.0 * math.pi * frequency * index / sample_rate)
        samples.append(sample)
    return tuple(samples)


def _example(label: str, midi_estimate: float) -> TrainingExample:
    return TrainingExample(
        label=label,
        features=(midi_estimate, 0.0, 0.9, -3.0, 0.1, 2.0, -1.0, -2.0, -3.0, -4.0),
        path=f"{label}.wav",
        pickup="Bridge",
        note=label,
        midi=int(midi_estimate),
        string=6,
        fret=0,
    )


if __name__ == "__main__":
    unittest.main()
