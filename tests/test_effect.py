import socket
import tempfile
import unittest
import json
import threading
from http.server import ThreadingHTTPServer
from pathlib import Path
from urllib.request import Request, urlopen
from unittest.mock import patch

import numpy as np

from ml_guitar_pedal.control import ModeServer
from ml_guitar_pedal.demo_ui import Handler
from ml_guitar_pedal.effect import build_parser
from ml_guitar_pedal.processing import Chorus, Delay, Fuzz, Overdrive, PedalGraph, SwitchableEffect, Tremolo


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

    def test_fuzz_hard_clips_and_keeps_silence_silent(self):
        self.assertTrue(np.array_equal(Fuzz(48_000).process(np.zeros(128, dtype="<i2")), np.zeros(128, dtype="<i2")))
        quiet = Fuzz(48_000).process(np.full(512, 1000, dtype="<i2"))
        loud = Fuzz(48_000).process(np.full(512, 10000, dtype="<i2"))
        self.assertEqual(int(quiet[-1]), int(loud[-1]))
        self.assertGreater(int(quiet[-1]), 0)
        self.assertLess(int(quiet[-1]), 32767)

    def test_switches_between_overdrive_and_fuzz_with_a_fade(self):
        effect = SwitchableEffect(Overdrive(48_000, 20.0, 3_000.0, 1.0, 0.5), 48_000, 1.0)
        signal = np.full(512, 1000, dtype="<i2")
        before = effect.process(signal)
        effect.set_effect_type("fuzz")
        during = effect.process(signal)
        self.assertLess(abs(int(during[0]) - int(before[-1])), 100)
        self.assertNotEqual(int(during[-1]), int(before[-1]))
        self.assertEqual(effect.graph_wet, 1.0)
        self.assertEqual(effect.graph.pedals, ("fuzz",))
        effect.set_mode("clean")
        effect.process(signal)
        np.testing.assert_array_equal(effect.process(signal), signal)
        effect.set_effect_type("overdrive")
        self.assertEqual(effect.graph.pedals, ("overdrive",))
        with self.assertRaises(ValueError):
            effect.set_effect_type("invalid")

    def test_pedal_graph_order_changes_signal_and_edges(self):
        signal = np.array([1000, -800, 1400, -1200] * 128, dtype="<i2")
        first = SwitchableEffect(Overdrive(48_000, 20.0, 3_000.0, 1.0, 0.5), 48_000, 1.0)
        second = SwitchableEffect(Overdrive(48_000, 20.0, 3_000.0, 1.0, 0.5), 48_000, 1.0)
        first.set_board(("overdrive", "fuzz"))
        second.set_board(("fuzz", "overdrive"))
        first.process(signal)
        second.process(signal)
        self.assertFalse(np.array_equal(first.process(signal), second.process(signal)))
        self.assertEqual(first.graph.edges, (("input", "overdrive"), ("overdrive", "fuzz"), ("fuzz", "output")))
        for pedals in (("fuzz", "fuzz"), ("invalid",), ("overdrive", "fuzz", "overdrive")):
            with self.assertRaises(ValueError):
                PedalGraph(pedals)

    def test_removing_every_pedal_fades_to_clean(self):
        effect = SwitchableEffect(Overdrive(48_000, 20.0, 3_000.0, 1.0, 0.5), 48_000, 1.0)
        signal = np.full(512, 1000, dtype="<i2")
        before = effect.process(signal)
        effect.set_board(())
        during = effect.process(signal)
        self.assertLess(abs(int(during[0]) - int(before[-1])), 100)
        np.testing.assert_array_equal(effect.process(signal), signal)
        self.assertEqual(effect.graph.edges, (("input", "output"),))

    def test_slots_keep_a_single_pedal_on_the_right(self):
        graph = PedalGraph((None, "fuzz"))
        self.assertEqual(graph.slots, (None, "fuzz"))
        self.assertEqual(graph.pedals, ("fuzz",))
        self.assertEqual(graph.edges, (("input", "fuzz"), ("fuzz", "output")))
        effect = SwitchableEffect(Overdrive(48_000, 20.0, 3_000.0, 1.0, 0.5), 48_000, 1.0)
        effect.set_slots((None, "fuzz"))
        effect.process(np.full(512, 1000, dtype="<i2"))
        self.assertEqual(effect.graph.slots, (None, "fuzz"))
        effect.set_slots(("fuzz", None))
        self.assertEqual(effect.graph.slots, ("fuzz", None))
        self.assertEqual(effect.graph_wet, 1.0)  # A visual move does not change the audio path.
        with self.assertRaises(ValueError):
            effect.set_slots(("fuzz", "fuzz"))

    def test_pedal_settings_are_independent_and_validated(self):
        effect = SwitchableEffect(Overdrive(48_000, 20.0, 3_000.0, 1.0, 0.5), 48_000, 1.0)
        effect.set_pedal_config("overdrive", "drive", 35.0)
        effect.set_pedal_config("fuzz", "tone", 4_000.0)
        self.assertEqual(effect.settings["overdrive"]["drive"], 35.0)
        self.assertEqual(effect.settings["fuzz"]["tone"], 4_000.0)
        self.assertEqual(effect.settings["overdrive"]["tone"], 3_000.0)
        for pedal, name, value in (("fuzz", "mix", 0.5), ("fuzz", "tone", 30_000.0), ("overdrive", "drive", float("nan"))):
            with self.assertRaises(ValueError):
                effect.set_pedal_config(pedal, name, value)

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
                    state = json.loads(client.recv(2048))
                    self.assertEqual(state["amount"], 0.25)
                    self.assertFalse(state["enabled"])
                self.assertEqual(effect.set_mode("effect"), "effect")
                self.assertEqual(effect.target, 0.25)
                with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as client:
                    client.connect(str(path))
                    client.sendall(b"fuzz")
                    server.poll()
                    state = json.loads(client.recv(2048))
                    self.assertEqual(state["effect_type"], "fuzz")
                    self.assertEqual(state["amount"], 0.25)
                with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as client:
                    client.connect(str(path))
                    client.sendall(b"board fuzz,overdrive")
                    server.poll()
                    state = json.loads(client.recv(2048))
                    self.assertEqual(state["pedals"], ["fuzz", "overdrive"])
                    self.assertEqual(state["graph"]["edges"], [["input", "fuzz"], ["fuzz", "overdrive"], ["overdrive", "output"]])
                with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as client:
                    client.connect(str(path))
                    client.sendall(b"board overdrive,fuzz,delay,tremolo,chorus")
                    server.poll()
                    state = json.loads(client.recv(4096))
                    self.assertEqual(state["pedals"], ["overdrive", "fuzz", "delay", "tremolo", "chorus"])
                with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as client:
                    client.connect(str(path))
                    client.sendall(b"slots -,fuzz")
                    server.poll()
                    state = json.loads(client.recv(2048))
                    self.assertEqual(state["slots"], [None, "fuzz"])
                with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as client:
                    client.connect(str(path))
                    client.sendall(b"config fuzz drive 25")
                    server.poll()
                    state = json.loads(client.recv(2048))
                    self.assertEqual(state["settings"]["fuzz"]["drive"], 25.0)
            self.assertFalse(path.exists())

    def test_effect_amount_rejects_out_of_range_values(self):
        effect = SwitchableEffect(Overdrive(48_000, 20.0, 3_000.0, 1.0, 0.5), 48_000, 1.0)
        for value in (-0.1, 1.1, float("nan")):
            with self.assertRaises(ValueError):
                effect.set_amount(value)

    def test_effect_defaults_match_live_low_latency_setup(self):
        options = build_parser().parse_args([])
        self.assertEqual((options.rate, options.block, options.drive), (48_000, 128, 20.0))
        self.assertEqual((options.fuzz_drive, options.fuzz_tone, options.fuzz_level), (15.0, 2_500.0, 0.45))

    def test_running_pedal_can_import_installed_lv2_effect(self):
        class InstalledWorld:
            def available(self):
                return [("urn:test:echo", "Test Echo")]

        class InstalledEffect:
            def __init__(self, world, uri, sample_rate):
                self.uri = uri
                self.display_name = "Test Echo"
                self.controls = {"gain": (0, 0.5, 0.0, 1.0)}
                self.settings = {"gain": 0.5}

            def process(self, samples):
                return samples

            def set_parameter(self, name, value):
                self.settings[name] = value

        effect = SwitchableEffect(Overdrive(48_000, 20, 3_000, 1, .5), 48_000, 1)
        with tempfile.TemporaryDirectory() as directory, patch(
            "ml_guitar_pedal.lv2_host.LV2Processor", InstalledEffect
        ):
            with ModeServer(effect, Path(directory) / "pedal.sock", lv2_world=InstalledWorld()) as server:
                def send(command):
                    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as client:
                        client.connect(str(server.path))
                        client.sendall(command.encode())
                        server.poll()
                        return client.recv(8192).decode().strip()

                listing = json.loads(send("lv2-list"))
                self.assertEqual(listing["plugins"][0]["loaded_as"], None)
                state = json.loads(send("lv2-load urn:test:echo"))
                self.assertEqual(state["available"]["lv2-1"]["name"], "Test Echo")
                self.assertEqual(state["available"]["lv2-1"]["uri"], "urn:test:echo")
                self.assertEqual(json.loads(send("lv2-list"))["plugins"][0]["loaded_as"], "lv2-1")
                self.assertEqual(len([key for key in json.loads(send("lv2-load urn:test:echo"))["available"] if key.startswith("lv2-")]), 1)
                state = json.loads(send("board lv2-1,delay"))
                self.assertEqual(state["pedals"], ["lv2-1", "delay"])

    def test_browser_can_list_and_import_installed_lv2_effect(self):
        commands = []

        def respond(command):
            commands.append(command)
            if command == "lv2-list":
                return json.dumps({"plugins": [{"uri": "urn:test:echo", "name": "Test Echo", "loaded_as": None}]})
            if command == "lv2-load urn:test:echo":
                return json.dumps({"available": {"lv2-1": {"name": "Test Echo"}}})
            if command == "state":
                return json.dumps({"available": {"lv2-1": {"name": "Test Echo"}}, "pedals": []})
            raise AssertionError(command)

        with patch("ml_guitar_pedal.demo_ui.send_mode_command", side_effect=respond):
            server = ThreadingHTTPServer(("127.0.0.1", 0), Handler)
            thread = threading.Thread(target=server.serve_forever, daemon=True)
            thread.start()
            try:
                base = f"http://127.0.0.1:{server.server_port}"
                with urlopen(base + "/api/lv2") as response:
                    listing = json.load(response)
                self.assertEqual(listing["plugins"][0]["name"], "Test Echo")
                request = Request(base + "/api/import", json.dumps({"uri": "urn:test:echo"}).encode(),
                                  {"Content-Type": "application/json"}, method="POST")
                with urlopen(request) as response:
                    state = json.load(response)
                self.assertIn("lv2-1", state["available"])
                self.assertEqual(commands, ["lv2-list", "lv2-load urn:test:echo", "state"])
            finally:
                server.shutdown()
                server.server_close()
                thread.join()

    def test_new_pedals_process_audio_and_validate_settings(self):
        signal = np.full(1024, 4000, dtype="<i2")
        for pedal, setting, value in ((Delay(48_000), "time", 20),
                                      (Tremolo(48_000), "rate", 8),
                                      (Chorus(48_000), "depth", 0.8)):
            pedal.set_parameter(setting, value)
            result = pedal.process(signal)
            self.assertEqual(result.shape, signal.shape)
            self.assertEqual(result.dtype, signal.dtype)
            with self.assertRaises(ValueError):
                pedal.set_parameter(setting, float("nan"))
        delay = Delay(48_000)
        delay.set_parameter("time", 20)
        delay.set_parameter("mix", 1)
        impulse = np.zeros(1100, dtype="<i2")
        impulse[0] = 10000
        result = delay.process(impulse)
        self.assertGreater(int(result[960]), 9000)
        self.assertEqual(int(result[0]), 0)

    def test_new_pedals_can_be_selected_and_configured(self):
        effect = SwitchableEffect(Overdrive(48_000, 20, 3000, 1, .5), 48_000, 1)
        for name in ("delay", "tremolo", "chorus"):
            effect.set_board((name,))
            self.assertEqual(effect.graph.pedals, (name,))
            self.assertIn(name, effect.available_pedals)
        effect.set_pedal_config("delay", "feedback", .6)
        self.assertEqual(effect.settings["delay"]["feedback"], .6)
        with self.assertRaises(ValueError):
            effect.set_pedal_config("delay", "feedback", 1)

    def test_board_grows_and_preserves_order(self):
        effect = SwitchableEffect(Overdrive(48_000, 20, 3000, 1, .5), 48_000, 1)
        chain = ("overdrive", "fuzz", "delay", "tremolo", "chorus")
        effect.set_board(chain)
        self.assertEqual(effect.graph.pedals, chain)
        self.assertEqual(effect.graph.slots, chain)
        self.assertEqual(len(effect.graph.edges), 6)
        signal = np.full(512, 1500, dtype="<i2")
        self.assertEqual(effect.process(signal).shape, signal.shape)
        effect.set_board(("chorus", "delay", "fuzz"))
        self.assertEqual(effect.graph.pedals, ("chorus", "delay", "fuzz"))
        with self.assertRaises(ValueError):
            PedalGraph(("fuzz",) * 33)


if __name__ == "__main__":
    unittest.main()
