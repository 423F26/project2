"""Run the window lifecycle check with xvfb-run python -m unittest discover -s tests."""
import os
import time
import unittest
from pathlib import Path
from unittest.mock import patch


@unittest.skipUnless(os.environ.get("DISPLAY"), "requires a display or xvfb-run")
class GuiTests(unittest.TestCase):
    def test_capture_graph_stop_and_close(self):
        import tkinter as tk
        import numpy as np
        from ml_guitar_pedal.gui import GuitarWindow
        from ml_guitar_pedal.live import LiveResult

        closed = []

        def capture(device, seconds, *, stop_event):
            try:
                while not stop_event.is_set():
                    yield np.zeros(256)
                    time.sleep(0.01)
            finally:
                closed.append(True)

        def pump_until(root, predicate):
            deadline = time.monotonic() + 3
            while not predicate() and time.monotonic() < deadline:
                root.update()
                time.sleep(0.01)
            self.assertTrue(predicate())

        root = tk.Tk()
        try:
            with patch("ml_guitar_pedal.gui.input_devices", return_value=[
                {"name": "irig", "description": "iRig HD 2"}
            ]), patch("ml_guitar_pedal.gui.capture_blocks", side_effect=capture), \
                 patch("ml_guitar_pedal.gui.load_model"), \
                 patch("ml_guitar_pedal.gui.classify_frame", return_value=LiveResult("A2", -20, 110, 0.99)):
                window = GuitarWindow(root, Path(__file__))
                pump_until(root, lambda: str(window.start_button["state"]) == "normal")
                window.start()
                pump_until(root, lambda: len(window.history) >= 3)
                self.assertEqual(window.note["text"], "A2")
                self.assertGreater(len(window.canvas.find_all()), 50)
                window.stop()
                pump_until(root, lambda: str(window.start_button["state"]) == "normal")
                self.assertTrue(closed)
                window.clear()
                self.assertFalse(window.history)
                window.start()
                pump_until(root, lambda: len(window.history) >= 3)
                window.close()
                pump_until(root, lambda: not window.worker.is_alive())
                self.assertEqual(len(closed), 2)
        finally:
            try:
                root.destroy()
            except tk.TclError:
                pass
