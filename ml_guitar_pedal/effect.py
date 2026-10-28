"""Run the live guitar effect between ALSA capture and playback devices."""

from __future__ import annotations

import argparse
import math

import numpy as np

from ml_guitar_pedal.alsa_pcm import AlsaPcm, available_devices
from ml_guitar_pedal.control import ModeServer
from ml_guitar_pedal.processing import Fuzz, Overdrive, SwitchableEffect


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
    parser = argparse.ArgumentParser(description="Live guitar pedal board through ALSA audio devices.")
    parser.add_argument("--input", help="ALSA capture device, e.g. plughw:1,0")
    parser.add_argument("--output", help="ALSA playback device, e.g. plughw:1,0")
    parser.add_argument("--list-devices", action="store_true", help="Show ALSA capture and playback devices")
    parser.add_argument("--list-lv2", action="store_true", help="List installed compatible mono LV2 effects")
    parser.add_argument("--lv2", action="append", default=[], metavar="URI", help="Load an installed LV2 effect into the rack (repeatable)")
    parser.add_argument("--rate", type=int, default=48_000)
    parser.add_argument("--block", type=int, default=128)
    parser.add_argument("--drive", type=float, default=20.0, help="Overdrive gain (at least 1)")
    parser.add_argument("--tone", type=float, default=3_000.0, help="Overdrive low pass cutoff in Hz")
    parser.add_argument("--mix", type=float, default=1.0, help="Overdrive wet mix from 0 to 1")
    parser.add_argument("--level", type=float, default=0.5, help="Overdrive output level from 0 to 1")
    parser.add_argument("--fuzz-drive", type=float, default=15.0, help="Fuzz input gain (at least 1)")
    parser.add_argument("--fuzz-tone", type=float, default=2_500.0, help="Fuzz low pass cutoff in Hz")
    parser.add_argument("--fuzz-level", type=float, default=0.45, help="Fuzz output level from 0 to 1")
    parser.add_argument("--clean-level", type=float, default=1.0, help="Clean output level from 0 to 1")
    parser.add_argument("--meter", action="store_true", help="Log input level and ALSA recoveries every 2 seconds")
    return parser


def main(argv: list[str] | None = None) -> None:
    parser = build_parser()
    args = parser.parse_args(argv)
    if args.list_lv2:
        from ml_guitar_pedal.lv2_host import LV2World
        world = LV2World()
        try:
            for uri, name in world.available():
                print(f"{name}\t{uri}")
        finally:
            world.close()
        return
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
        or args.fuzz_drive < 1 or not 0 < args.fuzz_tone < args.rate / 2
        or not 0 <= args.fuzz_level <= 1
    ):
        parser.error("invalid rate, block, overdrive, fuzz, or clean level setting")
    if not (args.input or inputs):
        parser.error("no ALSA capture device found; connect a USB audio interface and check --list-devices")
    if not (args.output or outputs):
        parser.error("no ALSA playback device found; connect an output device and check --list-devices")

    input_device = args.input or inputs[0]
    output_device = args.output or (input_device if input_device in outputs else outputs[0])
    world = None
    lv2_processors = {}
    if args.lv2:
        from ml_guitar_pedal.lv2_host import LV2Processor, LV2World
        world = LV2World()
        try:
            for index, uri in enumerate(dict.fromkeys(args.lv2), 1):
                lv2_processors[f"lv2-{index}"] = LV2Processor(world, uri, args.rate)
        except (ValueError, RuntimeError) as error:
            lv2_processors.clear()
            world.close()
            parser.error(str(error))
    effect = SwitchableEffect(
        Overdrive(args.rate, args.drive, args.tone, args.mix, args.level),
        args.rate,
        args.clean_level,
        Fuzz(args.rate, args.fuzz_drive, args.fuzz_tone, args.fuzz_level), lv2_processors,
    )
    meter = AudioMeter(args.rate) if args.meter else None

    controller = None
    try:
        with (
            AlsaPcm(input_device, AlsaPcm.CAPTURE, args.rate, args.block) as capture,
            AlsaPcm(output_device, AlsaPcm.PLAYBACK, args.rate, args.block) as playback,
            ModeServer(effect, lv2_world=world) as controller,
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
    finally:
        active_world = controller.lv2_world if controller is not None else world
        if active_world is not None:
            # Release plugin instances before the metadata world.
            effect._previous_processors = None
            effect._processors.clear()
            lv2_processors.clear()
            del effect
            active_world.close()


if __name__ == "__main__":
    main()
