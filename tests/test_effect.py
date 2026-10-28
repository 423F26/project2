"""Integration checks for the native C pedal engine and its Python adapters."""

import json
import os
import socket
import subprocess
import sys
import tempfile
import threading
import time
import unittest
from http.server import ThreadingHTTPServer
from pathlib import Path
from unittest.mock import patch
from urllib.request import Request, urlopen

from ml_guitar_pedal.demo_ui import Handler
from ml_guitar_pedal.effect import build_parser, native_binary


class NativeEffectTests(unittest.TestCase):
    def test_effect_defaults(self):
        options = build_parser().parse_args([])
        self.assertEqual((options.rate, options.block, options.drive), (48_000, 128, 20.0))
        self.assertEqual((options.fuzz_drive, options.fuzz_tone, options.fuzz_level), (15.0, 2_500.0, 0.45))

    def setUp(self):
        try:
            binary = native_binary()
        except SystemExit:
            self.skipTest("native pedal is not built; run cmake -S native_pedal -B build/native && cmake --build build/native")
        self.directory = tempfile.TemporaryDirectory()
        self.path = Path(self.directory.name) / "pedal.sock"
        environment = {**os.environ, "PEDAL_CONTROL_SOCKET": str(self.path)}
        self.process = subprocess.Popen([sys.executable, "-m", "ml_guitar_pedal.cli", "effect", "--no-audio"],
                                        env=environment, stdout=subprocess.DEVNULL, stderr=subprocess.PIPE)
        for _ in range(200):
            if self.path.exists():
                break
            if self.process.poll() is not None:
                self.fail(f"native pedal exited: {self.process.stderr.read().decode()}")
            time.sleep(0.01)
        self.assertTrue(self.path.exists())

    def tearDown(self):
        if hasattr(self, "process"):
            self.process.terminate()
            self.process.wait(timeout=5)
            self.process.stderr.close()
        if hasattr(self, "directory"):
            self.directory.cleanup()

    def send(self, command):
        with socket.socket(socket.AF_UNIX) as client:
            client.connect(str(self.path))
            client.sendall(command.encode())
            chunks = []
            while True:
                data = client.recv(4096)
                if not data:
                    break
                chunks.append(data)
                if b"\n" in data:
                    break
        return b"".join(chunks).decode().strip()

    def test_socket_commands_and_graph(self):
        state = json.loads(self.send("state"))
        self.assertEqual(state["pedals"], ["overdrive"])
        state = json.loads(self.send("board overdrive,fuzz,delay,tremolo,chorus"))
        self.assertEqual(len(state["pedals"]), 5)
        self.assertEqual(state["graph"]["edges"][-1], ["chorus", "output"])
        state = json.loads(self.send("config delay time 450"))
        self.assertEqual(state["settings"]["delay"]["time"], 450)
        self.assertTrue(self.send("config delay time 2000").startswith("error:"))
        state = json.loads(self.send("slots -,fuzz"))
        self.assertEqual(state["slots"], [None, "fuzz"])
        self.assertEqual(state["pedals"], ["fuzz"])
        self.assertEqual(self.send("clean"), "clean")
        self.assertEqual(self.send("effect"), "effect")
        self.assertTrue(self.send("board fuzz,fuzz").startswith("error:"))
        self.assertEqual(json.loads(self.send("board -"))["pedals"], [])

    def test_installed_lv2_effect_can_be_imported(self):
        plugins = json.loads(self.send("lv2-list"))["plugins"]
        if not plugins:
            self.skipTest("no compatible LV2 plugins installed on test machine")
        plugin = plugins[0]
        state = json.loads(self.send("lv2-load " + plugin["uri"]))
        self.assertEqual(state["available"]["lv2-1"]["uri"], plugin["uri"])
        state = json.loads(self.send("lv2-load " + plugin["uri"]))
        self.assertEqual(len([name for name in state["available"] if name.startswith("lv2-")]), 1)
        self.assertEqual(json.loads(self.send("board lv2-1,delay"))["pedals"], ["lv2-1", "delay"])
        listing = json.loads(self.send("lv2-list"))["plugins"]
        self.assertEqual(next(item for item in listing if item["uri"] == plugin["uri"])["loaded_as"], "lv2-1")

    def test_browser_import_endpoints_use_native_engine(self):
        with patch("ml_guitar_pedal.demo_ui.send_mode_command", side_effect=self.send):
            server = ThreadingHTTPServer(("127.0.0.1", 0), Handler)
            thread = threading.Thread(target=server.serve_forever, daemon=True)
            thread.start()
            try:
                base = f"http://127.0.0.1:{server.server_port}"
                with urlopen(base + "/api/state") as response:
                    self.assertEqual(json.load(response)["pedals"], ["overdrive"])
                with urlopen(base + "/api/lv2") as response:
                    plugins = json.load(response)["plugins"]
                if plugins:
                    uri = plugins[0]["uri"]
                    request = Request(base + "/api/import", json.dumps({"uri": uri}).encode(),
                                      {"Content-Type": "application/json"}, method="POST")
                    with urlopen(request) as response:
                        self.assertEqual(json.load(response)["available"]["lv2-1"]["uri"], uri)
                request = Request(base + "/api/board", json.dumps({"pedals": ["delay", "chorus"]}).encode(),
                                  {"Content-Type": "application/json"}, method="POST")
                with urlopen(request) as response:
                    self.assertEqual(json.load(response)["pedals"], ["delay", "chorus"])
            finally:
                server.shutdown()
                server.server_close()
                thread.join()


if __name__ == "__main__":
    unittest.main()
