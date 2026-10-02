import socket
import tempfile
import unittest
import json
from pathlib import Path

import numpy as np

from ml_guitar_pedal.control import ModeServer
from ml_guitar_pedal.effect import build_parser
from ml_guitar_pedal.processing import Overdrive, SwitchableEffect


class OverdriveTests(unittest.TestCase):
    def test_silence_stays_silent(self):
        effect = Overdrive(48_000, 3.0, 5_000.0, 1.0, 0.7)
        self.assertTrue(np.array_equal(effect.process(np.zeros(128, dtype="<i2")), np.zeros(128, dtype="<i2")))

    def test_dry_mix_scales_input(self):
        effect = Overdrive(48_000, 3.0, 5_000.0, 0.0, 0.5)
        result = effect.process(np.array([0, 10000, -10000], dtype="<i2"))
        np.testing.assert_allclose(result, [0, 5000, -5000], atol=1)

    def test_filter_state_continues_between_blocks(self):
        effect = Overdrive(48_000, 3.0, 1_000.0, 1.0, 1.0)
        effect.process(np.full(128, 10000, dtype="<i2"))
        self.assertGreater(int(effect.process(np.zeros(1, dtype="<i2"))[0]), 0)

    def test_live_mode_switch_fades_to_clean_and_back(self):
        effect = SwitchableEffect(Overdrive(48_000, 20.0, 3_000.0, 1.0, 0.5), 48_000, 1.0)
        signal = np.full(512, 1000, dtype="<i2")
        effected = effect.process(signal)
        self.assertEqual(effect.set_mode("clean"), "clean")
        faded = effect.process(signal)
        self.assertNotEqual(int(faded[0]), int(faded[-1]))
        np.testing.assert_array_equal(effect.process(signal), signal)
        self.assertEqual(effect.set_mode("toggle"), "effect")
        self.assertGreater(int(effect.process(signal)[-1]), int(signal[-1]))

    def test_mode_socket_switches_without_restarting_audio(self):
        effect = SwitchableEffect(Overdrive(48_000, 20.0, 3_000.0, 1.0, 0.5), 48_000, 1.0)
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "pedal.sock"
            with ModeServer(effect, path) as server:
                with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as client:
                    client.connect(str(path))
                    client.sendall(b"toggle")
                    server.poll()
                    self.assertEqual(client.recv(64), b"clean\n")
                self.assertEqual(effect.mode, "clean")
                with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as client:
                    client.connect(str(path))
                    client.sendall(b"amount 0.25")
                    server.poll()
                    state = json.loads(client.recv(128))
                    self.assertEqual(state["amount"], 0.25)
                    self.assertFalse(state["enabled"])
                self.assertEqual(effect.set_mode("effect"), "effect")
                self.assertEqual(effect.target, 0.25)
            self.assertFalse(path.exists())

    def test_effect_amount_rejects_out_of_range_values(self):
        effect = SwitchableEffect(Overdrive(48_000, 20.0, 3_000.0, 1.0, 0.5), 48_000, 1.0)
        for value in (-0.1, 1.1, float("nan")):
            with self.assertRaises(ValueError):
                effect.set_amount(value)

    def test_effect_defaults_match_live_low_latency_setup(self):
        options = build_parser().parse_args([])
        self.assertEqual((options.rate, options.block, options.drive), (48_000, 128, 20.0))


if __name__ == "__main__":
    unittest.main()
