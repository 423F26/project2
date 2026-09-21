from __future__ import annotations

import unittest
from unittest.mock import Mock, patch

import numpy as np

from ml_guitar_pedal.audio import AudioSignal
from ml_guitar_pedal.cli import build_parser
from ml_guitar_pedal.features import extract_features
from ml_guitar_pedal.live import classify_frame, input_devices, select_device
from ml_guitar_pedal.model import KnnPitchClassifier, TrainingExample
from ml_guitar_pedal.streaming import StreamingFrameBuffer


class LiveTests(unittest.TestCase):
    def test_silence_and_dc_do_not_reach_classifier(self):
        classifier = Mock()
        for value in (0.0, 0.1):
            result = classify_frame(AudioSignal(8000, (value,) * 512), classifier)
            self.assertEqual(result.status, "quiet")
        classifier.predict.assert_not_called()

    def test_noise_does_not_get_a_note_label(self):
        classifier = Mock()
        noise = np.random.default_rng(5).normal(0, 0.1, 512)
        result = classify_frame(AudioSignal(8000, tuple(noise)), classifier)
        self.assertEqual(result.status, "uncertain")
        classifier.predict.assert_not_called()

    def test_streamed_notes_use_trained_classifier(self):
        classifier = KnnPitchClassifier(k=1)
        examples = []
        signals = []
        for label, hz, midi in (("E2", 82.407, 40), ("A2", 110, 45), ("E4", 329.628, 64)):
            samples = 0.3 * np.sin(2 * np.pi * hz * np.arange(8000) / 8000)
            signal = AudioSignal(8000, tuple(samples))
            signals.append((label, signal))
            examples.append(TrainingExample(label, extract_features(signal).values,
                                            "synthetic.wav", "Bridge", label, midi, 6, 0))
        classifier.fit(examples)
        for label, signal in signals:
            buffer = StreamingFrameBuffer(sample_rate=8000)
            frames = []
            for start in range(0, len(signal.samples), 137):
                frames.extend(buffer.push(signal.samples[start:start + 137]))
            for frame in frames:
                self.assertEqual(classify_frame(frame.signal, classifier).status, label)

    def test_capture_sources_exclude_output_monitors(self):
        with patch("ml_guitar_pedal.live.shutil.which", return_value="pactl"), \
             patch("ml_guitar_pedal.live.subprocess.run") as run:
            run.return_value = Mock(returncode=0, stdout='[{"name":"irig.monitor"},'
                                   '{"name":"irig.input","description":"iRig HD 2"}]')
            devices = input_devices()
        self.assertEqual(select_device(devices, None)["name"], "irig.input")

    def test_selection_rejects_missing_or_ambiguous_irig(self):
        with self.assertRaises(ValueError):
            select_device([{"name": "internal mic"}], None)
        devices = [{"name": "irig.one"}, {"name": "irig.two"}]
        with self.assertRaises(ValueError):
            select_device(devices, None)
        self.assertEqual(select_device(devices, "irig.two")["name"], "irig.two")

    def test_live_parser(self):
        args = build_parser().parse_args(["live", "--seconds", "2", "--gate-db", "-60"])
        self.assertEqual(args.seconds, 2)
        self.assertEqual(args.gate_db, -60)
        self.assertIsNone(args.device)


if __name__ == "__main__":
    unittest.main()
