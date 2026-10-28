"""Compatibility launcher for the native C live pedal engine."""

from __future__ import annotations

import argparse
import os
import shutil
import sys
from pathlib import Path


def build_parser() -> argparse.ArgumentParser:
    """Describe the native command's public options for callers and tests."""
    parser = argparse.ArgumentParser(description="Live guitar pedal board through native ALSA audio.")
    parser.add_argument("--input")
    parser.add_argument("--output")
    parser.add_argument("--list-devices", action="store_true")
    parser.add_argument("--list-lv2", action="store_true")
    parser.add_argument("--lv2", action="append", default=[])
    parser.add_argument("--rate", type=int, default=48_000)
    parser.add_argument("--block", type=int, default=128)
    parser.add_argument("--drive", type=float, default=20.0)
    parser.add_argument("--tone", type=float, default=3_000.0)
    parser.add_argument("--mix", type=float, default=1.0)
    parser.add_argument("--level", type=float, default=0.5)
    parser.add_argument("--fuzz-drive", type=float, default=15.0)
    parser.add_argument("--fuzz-tone", type=float, default=2_500.0)
    parser.add_argument("--fuzz-level", type=float, default=0.45)
    parser.add_argument("--clean-level", type=float, default=1.0)
    parser.add_argument("--meter", action="store_true")
    parser.add_argument("--socket")
    parser.add_argument("--no-audio", action="store_true")
    return parser


def native_binary() -> Path:
    configured = os.environ.get("PEDAL_ENGINE_BIN")
    if configured:
        candidate = Path(configured).expanduser()
        if candidate.is_file() and os.access(candidate, os.X_OK):
            return candidate.resolve()
        raise SystemExit(f"PEDAL_ENGINE_BIN is not executable: {candidate}")
    local = Path(__file__).resolve().parents[1] / "build" / "native" / "pedal-engine"
    if local.is_file() and os.access(local, os.X_OK):
        return local
    installed = shutil.which("pedal-engine")
    if installed:
        return Path(installed)
    raise SystemExit(
        "Native pedal engine is not built. Run: "
        "cmake -S native_pedal -B build/native -DCMAKE_BUILD_TYPE=Release && "
        "cmake --build build/native -j"
    )


def main(argv: list[str] | None = None) -> None:
    binary = native_binary()
    arguments = sys.argv[1:] if argv is None else argv
    os.execv(binary, [str(binary), *arguments])


if __name__ == "__main__":
    main()
