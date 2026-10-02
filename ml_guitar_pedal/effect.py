"""Run the live guitar effect between ALSA capture and playback devices."""

from __future__ import annotations

import argparse
import math

import numpy as np

from ml_guitar_pedal.alsa_pcm import AlsaPcm, available_devices
from ml_guitar_pedal.control import ModeServer
from ml_guitar_pedal.processing import Overdrive, SwitchableEffect


class AudioMeter:
    def __init__(self, sample_rate: int):
        self.sample_rate = sample_rate
        self.frames = 0
        self.squares = 0.0
        self.peak = 0

    def update(self, samples: np.ndarray, capture: AlsaPcm, playback: AlsaPcm) -> None:
        signal = samples.astype(np.float32) / 32768.0
        self.frames += len(samples)
        self.squares += float(np.dot(signal, signal))
        self.peak = max(self.peak, int(np.abs(samples.astype(np.int32)).max()))
        if self.frames < self.sample_rate * 2:
            return
        rms = math.sqrt(self.squares / self.frames)
        print(
            f"input rms={rms:.4f} peak={self.peak / 32768:.4f} "
            f"capture_recoveries={capture.recoveries} playback_recoveries={playback.recoveries}",
            flush=True,
        )
        self.frames = 0
        self.squares = 0.0
        self.peak = 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Live guitar overdrive through ALSA audio devices.")
    parser.add_argument("--input", help="ALSA capture device, e.g. plughw:1,0")
    parser.add_argument("--output", help="ALSA playback device, e.g. plughw:1,0")
    parser.add_argument("--list-devices", action="store_true", help="Show ALSA capture and playback devices")
    parser.add_argument("--rate", type=int, default=48_000)
    parser.add_argument("--block", type=int, default=128)
    parser.add_argument("--drive", type=float, default=20.0, help="Overdrive gain (at least 1)")
    parser.add_argument("--tone", type=float, default=3_000.0, help="Low pass cutoff in Hz")
    parser.add_argument("--mix", type=float, default=1.0, help="Wet mix from 0 to 1")
    parser.add_argument("--level", type=float, default=0.5, help="Output level from 0 to 1")
    parser.add_argument("--clean-level", type=float, default=1.0, help="Clean output level from 0 to 1")
    parser.add_argument("--meter", action="store_true", help="Log input level and ALSA recoveries every 2 seconds")
    return parser


def main(argv: list[str] | None = None) -> None:
    parser = build_parser()
    args = parser.parse_args(argv)
    inputs, outputs = available_devices()
    if args.list_devices:
        print("capture:", ", ".join(inputs) or "none")
        print("playback:", ", ".join(outputs) or "none")
        return
    if (
        args.rate < 8_000 or args.block < 16 or args.drive < 1
        or not 0 < args.tone < args.rate / 2
        or not 0 <= args.mix <= 1 or not 0 <= args.level <= 1
        or not 0 <= args.clean_level <= 1
    ):
        parser.error("invalid rate, block, drive, tone, mix, level, or clean level")
    if not (args.input or inputs):
        parser.error("no ALSA capture device found; connect a USB audio interface and check --list-devices")
    if not (args.output or outputs):
        parser.error("no ALSA playback device found; connect an output device and check --list-devices")

    input_device = args.input or inputs[0]
    output_device = args.output or (input_device if input_device in outputs else outputs[0])
    effect = SwitchableEffect(
        Overdrive(args.rate, args.drive, args.tone, args.mix, args.level),
        args.rate,
        args.clean_level,
    )
    meter = AudioMeter(args.rate) if args.meter else None

    try:
        with (
            AlsaPcm(input_device, AlsaPcm.CAPTURE, args.rate, args.block) as capture,
            AlsaPcm(output_device, AlsaPcm.PLAYBACK, args.rate, args.block) as playback,
            ModeServer(effect) as controller,
        ):
            print(f"guitar effect: {input_device} -> {output_device}; mode=effect; Ctrl+C to stop", flush=True)
            while True:
                controller.poll()
                samples = capture.read()
                if len(samples):
                    if meter is not None:
                        meter.update(samples, capture, playback)
                    playback.write(effect.process(samples))
    except KeyboardInterrupt:
        pass


if __name__ == "__main__":
    main()
