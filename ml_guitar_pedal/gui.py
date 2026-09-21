"""Tkinter live pitch display; capture and inference run off the UI thread."""
from __future__ import annotations

import math
import queue
import threading
import tkinter as tk
from collections import deque
from pathlib import Path
from tkinter import ttk

from ml_guitar_pedal.dataset import midi_to_note
from ml_guitar_pedal.features import frequency_to_midi
from ml_guitar_pedal.live import SAMPLE_RATE, capture_blocks, classify_frame, input_devices
from ml_guitar_pedal.model import load_model
from ml_guitar_pedal.streaming import StreamingFrameBuffer


class GuitarWindow:
    def __init__(self, root: tk.Tk, model: Path):
        self.root, self.model = root, model
        self.events: queue.Queue = queue.Queue(maxsize=512)
        self.stop_event = threading.Event()
        self.worker: threading.Thread | None = None
        self.closing = False
        self.devices: list[dict] = []
        self.history: deque = deque(maxlen=600)
        self.latest_time = 0.0
        root.title("Guitar • Live note graph")
        root.geometry("1000x660")
        root.minsize(720, 480)
        root.protocol("WM_DELETE_WINDOW", self.close)

        panel = ttk.Frame(root, padding=20)
        panel.pack(fill="both", expand=True)
        ttk.Label(panel, text="LIVE GUITAR", font=("Sans", 12, "bold")).pack(anchor="w")
        controls = ttk.Frame(panel)
        controls.pack(fill="x", pady=(14, 10))
        self.device = ttk.Combobox(controls, state="readonly", width=38)
        self.device.pack(side="left", fill="x", expand=True)
        self.refresh_button = ttk.Button(controls, text="Refresh inputs", command=self.refresh)
        self.refresh_button.pack(side="left", padx=8)
        self.start_button = ttk.Button(controls, text="Start", command=self.start, state="disabled")
        self.start_button.pack(side="left")
        self.stop_button = ttk.Button(controls, text="Stop", command=self.stop, state="disabled")
        self.stop_button.pack(side="left", padx=(8, 0))

        settings = ttk.Frame(panel)
        settings.pack(fill="x")
        ttk.Label(settings, text="Silence gate (dBFS)").pack(side="left")
        self.gate = ttk.Entry(settings, width=7)
        self.gate.insert(0, "-50")
        self.gate.pack(side="left", padx=8)
        ttk.Label(settings, text="Pitch confidence minimum").pack(side="left", padx=(12, 0))
        self.confidence = ttk.Entry(settings, width=7)
        self.confidence.insert(0, "0.8")
        self.confidence.pack(side="left", padx=8)
        ttk.Button(settings, text="Clear graph", command=self.clear).pack(side="right")

        readout = ttk.Frame(panel)
        readout.pack(fill="x", pady=(16, 10))
        self.note = ttk.Label(readout, text="—", font=("Sans", 38, "bold"))
        self.note.pack(side="left")
        self.details = ttk.Label(readout, text="Ready to listen", justify="left")
        self.details.pack(side="left", padx=24)
        ttk.Label(panel, text="Detected pitch · last 15 seconds · E2–E6").pack(anchor="w", pady=(0, 6))
        self.canvas = tk.Canvas(panel, background="#101827", highlightthickness=0)
        self.canvas.pack(fill="both", expand=True)
        self.canvas.bind("<Configure>", lambda event: self.draw())
        self.status = ttk.Label(panel, text="Finding audio inputs…", wraplength=900)
        self.status.pack(anchor="w", pady=(10, 4))
        ttk.Label(panel, text="Play one clean note at a time. Gaps indicate silence or uncertain pitch. "
                  "Confidence measures pitch clarity, not classification probability.", wraplength=900).pack(anchor="w")
        self.refresh()
        root.after(40, self.poll)

    def emit(self, kind, value=None):
        # Keep capture responsive if the window is temporarily busy.
        try:
            self.events.put_nowait((kind, value))
        except queue.Full:
            try:
                self.events.get_nowait()
            except queue.Empty:
                pass
            self.events.put_nowait((kind, value))

    def refresh(self):
        self.refresh_button.configure(state="disabled")
        self.start_button.configure(state="disabled")

        def discover():
            try:
                self.emit("devices", input_devices())
            except Exception as error:
                self.emit("error", str(error))
            finally:
                self.emit("discovered")

        self.worker = threading.Thread(target=discover, daemon=True)
        self.worker.start()

    def start(self):
        index = self.device.current()
        if index < 0:
            self.status.configure(text="Select an audio input first.")
            return
        try:
            gate, confidence = float(self.gate.get()), float(self.confidence.get())
            if not math.isfinite(gate) or gate > 0 or not 0 <= confidence <= 1:
                raise ValueError
        except ValueError:
            self.status.configure(text="Use a finite gate at or below 0 dBFS and confidence between 0 and 1.")
            return
        device = self.devices[index]["name"]
        self.clear()
        self.stop_event.clear()
        self.set_running(True)
        self.status.configure(text="Listening — play a note.")

        def listen():
            try:
                if not self.model.exists():
                    raise ValueError(f"Model missing: {self.model}. Run pedal train first.")
                classifier = load_model(self.model)
                buffer = StreamingFrameBuffer(sample_rate=SAMPLE_RATE)
                blocks = capture_blocks(device, 0, stop_event=self.stop_event)
                try:
                    for block in blocks:
                        if self.stop_event.is_set():
                            break
                        for frame in buffer.push(block):
                            result = classify_frame(frame.signal, classifier, gate_db=gate,
                                                    min_confidence=confidence)
                            self.emit("frame", (frame.offset_seconds, result))
                finally:
                    blocks.close()
            except Exception as error:
                self.emit("error", str(error))
            finally:
                self.emit("stopped")

        self.worker = threading.Thread(target=listen, daemon=True)
        self.worker.start()

    def set_running(self, running):
        self.start_button.configure(state="disabled" if running or not self.devices else "normal")
        self.refresh_button.configure(state="disabled" if running else "normal")
        self.stop_button.configure(state="normal" if running else "disabled")
        self.device.configure(state="disabled" if running else "readonly")
        for entry in (self.gate, self.confidence):
            entry.configure(state="disabled" if running else "normal")

    def stop(self):
        self.stop_event.set()
        self.stop_button.configure(state="disabled")
        self.status.configure(text="Stopped.")

    def close(self):
        self.closing = True
        self.stop_event.set()
        self.root.withdraw()

    def clear(self):
        self.history.clear()
        self.draw()

    def poll(self):
        if self.closing:
            if self.worker is None or not self.worker.is_alive():
                self.root.destroy()
                return
            self.root.after(40, self.poll)
            return
        changed = False
        while True:
            try:
                kind, value = self.events.get_nowait()
            except queue.Empty:
                break
            if kind == "devices":
                self.devices = value
                self.device.configure(values=[d.get("description", d["name"]) for d in value])
                if value:
                    index = next((i for i, d in enumerate(value) if "irig" in
                                  (d["name"] + d.get("description", "")).lower()), 0)
                    self.device.current(index)
                else:
                    self.device.set("")
                self.status.configure(text="Ready. Press Start to listen." if value else "No inputs found. Connect the iRig and refresh.")
            elif kind in ("discovered", "stopped"):
                self.set_running(False)
                if kind == "stopped":
                    self.note.configure(text="—")
                    self.details.configure(text="Capture stopped")
            elif kind == "error":
                self.status.configure(text=value)
            elif kind == "frame":
                timestamp, result = value
                self.latest_time = timestamp
                pitch = frequency_to_midi(result.hz) if result.hz > 0 else None
                self.history.append((timestamp, pitch))
                while self.history and self.history[0][0] < timestamp - 15:
                    self.history.popleft()
                self.note.configure(text="—" if pitch is None else result.status)
                hz = f"{result.hz:.1f} Hz" if pitch is not None else result.status.capitalize()
                self.details.configure(text=f"{hz}   ·   {result.level_db:.1f} dBFS\nPitch confidence {result.confidence:.0%}")
                self.status.configure(text="CLIPPING — lower the iRig input gain." if result.clipped else
                                      "Listening — play one clean note at a time.")
                changed = True
        if changed:
            self.draw()
        self.root.after(40, self.poll)

    def draw(self):
        canvas = self.canvas
        canvas.delete("all")
        width, height = canvas.winfo_width(), canvas.winfo_height()
        left, right, top, bottom = 54, max(55, width - 18), 16, max(17, height - 30)
        def y(midi):
            return bottom - (midi - 40) / 48 * (bottom - top)
        for midi in range(40, 89):
            major = midi % 12 in (0, 4, 9)
            canvas.create_line(left, y(midi), right, y(midi), fill="#29374b" if major else "#1a2536")
            if major:
                canvas.create_text(left - 9, y(midi), text=midi_to_note(midi), anchor="e", fill="#acbad0")
        end = max(15, self.latest_time)
        start = end - 15
        for offset in range(0, 16, 3):
            x = left + offset / 15 * (right - left)
            canvas.create_line(x, top, x, bottom, fill="#29374b")
            canvas.create_text(x, bottom + 16, text=f"{start + offset:.0f}s", fill="#acbad0")
        previous = None
        for timestamp, pitch in self.history:
            if pitch is None or not 40 <= pitch <= 88 or timestamp < start:
                previous = None
                continue
            x = left + (timestamp - start) / 15 * (right - left)
            point = (x, y(pitch))
            if previous is not None and timestamp - previous[0] < 0.1 and abs(pitch - previous[1]) < 1.5:
                canvas.create_line(*previous[2], *point, fill="#5de4c7", width=3)
            else:
                canvas.create_oval(x - 2, point[1] - 2, x + 2, point[1] + 2, fill="#5de4c7", outline="")
            previous = (timestamp, pitch, point)


def launch(model: Path):
    root = tk.Tk()
    GuitarWindow(root, model)
    root.mainloop()
