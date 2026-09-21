"""Live mono capture through the Linux desktop's PipeWire audio server."""
from __future__ import annotations

import argparse
import json
import math
import os
import selectors
import shutil
import subprocess
import tempfile
import time
from threading import Event
from dataclasses import dataclass

import numpy as np

from ml_guitar_pedal.audio import AudioSignal
from ml_guitar_pedal.features import extract_features
from ml_guitar_pedal.model import KnnPitchClassifier, load_model
from ml_guitar_pedal.streaming import StreamingFrameBuffer

SAMPLE_RATE = 8_000


def input_devices() -> list[dict]:
    if not shutil.which("pactl"):
        raise ValueError("Live input needs pactl and pw-record (PipeWire / PulseAudio utilities).")
    result = subprocess.run(
        ["pactl", "--format=json", "list", "sources"],
        capture_output=True, text=True, timeout=5,
    )
    if result.returncode:
        raise ValueError(f"Cannot access audio inputs: {result.stderr.strip()}")
    return [source for source in json.loads(result.stdout)
            if not source["name"].endswith(".monitor")
            and source.get("properties", {}).get("device.class") != "monitor"]


def select_device(devices: list[dict], requested: str | None) -> dict:
    query = requested if requested is not None else "irig"
    exact = [device for device in devices if device["name"] == query]
    matches = exact or [device for device in devices
                        if query.lower() in (device["name"] + " " + device.get("description", "")).lower()]
    if len(matches) != 1:
        raise ValueError(f"Expected one input matching {query!r}, found {len(matches)}. "
                         "Use live --list-devices, then live --device NAME.")
    return matches[0]


@dataclass(frozen=True)
class LiveResult:
    status: str
    level_db: float
    hz: float = 0.0
    confidence: float = 0.0
    clipped: bool = False


def classify_frame(
    signal: AudioSignal, classifier: KnnPitchClassifier, *,
    gate_db: float = -50, min_confidence: float = 0.8,
) -> LiveResult:
    samples = np.asarray(signal.samples, dtype=np.float64)
    clipped = bool(np.max(np.abs(samples)) >= 0.999)
    samples = samples - samples.mean()
    level_db = 20 * math.log10(max(float(np.sqrt(np.mean(samples ** 2))), 1e-12))
    if level_db < gate_db:
        return LiveResult("quiet", level_db, clipped=clipped)
    features = extract_features(AudioSignal(signal.sample_rate, tuple(samples)))
    if features.confidence < min_confidence:
        return LiveResult("uncertain", level_db, confidence=features.confidence, clipped=clipped)
    prediction = classifier.predict(features.values)
    return LiveResult(prediction.label, level_db, features.estimated_hz, features.confidence, clipped)


def capture_blocks(device: str, seconds: float, *, stop_event: Event | None = None):
    """Yield resampled float PCM; always reap the recorder, including on Ctrl+C."""
    if not shutil.which("pw-record"):
        raise ValueError("Live input needs pw-record from PipeWire.")
    command = ["pw-record", "--target", device, "--rate", str(SAMPLE_RATE),
               "--channels", "1", "--format", "f32", "--raw", "--latency", "32ms", "-"]
    with tempfile.TemporaryFile() as errors:
        process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=errors)
        try:
            assert process.stdout is not None
            with selectors.DefaultSelector() as selector:
                selector.register(process.stdout, selectors.EVENT_READ)
                started = last_data = time.monotonic()
                pending = b""
                while not seconds or time.monotonic() - started < seconds:
                    if stop_event is not None and stop_event.is_set():
                        return
                    if not selector.select(timeout=0.1):
                        if time.monotonic() - last_data > 5:
                            raise ValueError("No audio received for 5 seconds. Check the iRig connection.")
                        continue
                    raw = os.read(process.stdout.fileno(), 4096)
                    if not raw:
                        errors.seek(0)
                        detail = errors.read().decode(errors="replace").strip()
                        raise ValueError(f"Audio capture stopped. {detail}")
                    last_data = time.monotonic()
                    pending += raw
                    end = len(pending) // 4 * 4
                    if end:
                        yield np.frombuffer(pending[:end], dtype="=f4")
                        pending = pending[end:]
        finally:
            if process.poll() is None:
                process.terminate()
            try:
                process.wait(timeout=2)
            except subprocess.TimeoutExpired:
                process.kill()
                process.wait()
            if process.stdout:
                process.stdout.close()


def live_command(args: argparse.Namespace) -> None:
    try:
        if not math.isfinite(args.seconds) or args.seconds < 0:
            raise ValueError("seconds must be finite and nonnegative")
        if not math.isfinite(args.gate_db) or args.gate_db > 0:
            raise ValueError("gate-db must be finite and at most 0")
        if not 0 <= args.min_confidence <= 1:
            raise ValueError("min-confidence must be between 0 and 1")
        devices = input_devices()
        if args.list_devices:
            for device in devices:
                print(f"{device['name']}  ({device.get('description', '')})")
            return
        device = select_device(devices, args.device)
        if not args.model.exists():
            raise ValueError(f"Model missing: {args.model}. Run pedal train first.")
        classifier = load_model(args.model)
        print(f"Input: {device.get('description', device['name'])}", flush=True)
        print("Play one clean note at a time. Ctrl+C stops. Pitch confidence is not model probability.", flush=True)
        buffer = StreamingFrameBuffer(sample_rate=SAMPLE_RATE)
        last_status = None
        last_output = -1.0
        blocks = capture_blocks(device["name"], args.seconds)
        try:
            for block in blocks:
                for frame in buffer.push(block):
                    result = classify_frame(frame.signal, classifier, gate_db=args.gate_db,
                                            min_confidence=args.min_confidence)
                    if result.status == last_status and (
                        result.status == "quiet" or frame.offset_seconds - last_output < 0.25
                    ):
                        continue
                    pitch = f"  {result.hz:7.1f} Hz" if result.hz else ""
                    clip = "  CLIPPING: lower input gain" if result.clipped else ""
                    print(f"{frame.offset_seconds:7.2f}s  {result.status:>9}  "
                          f"{result.level_db:6.1f} dBFS{pitch}  "
                          f"pitch confidence={result.confidence:.2f}{clip}", flush=True)
                    last_status, last_output = result.status, frame.offset_seconds
        finally:
            blocks.close()
    except KeyboardInterrupt:
        print("\nStopped live input.")
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        # Keep the interactive shell usable while giving command-line callers a failure status.
        if args.command == "live":
            raise SystemExit(f"Live input: {error}") from error
        raise ValueError(str(error)) from error
