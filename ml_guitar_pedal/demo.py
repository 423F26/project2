"""Classify a clean guitar WAV and locate a matching blues-driver recording."""

from __future__ import annotations

import argparse
from pathlib import Path

from ml_guitar_pedal.audio import read_wav_mono
from ml_guitar_pedal.dataset import ToneSample, scan_clean_tones
from ml_guitar_pedal.features import extract_features
from ml_guitar_pedal.model import load_model


def matching_blues_file(note: str, blues_dir: Path, pickup: str) -> Path:
    candidates = [sample for sample in scan_clean_tones(blues_dir) if sample.note == note]
    if not candidates:
        raise ValueError(f"No blues-driver WAV matches classified note {note}")

    # A note can be played on several strings. Prefer the input pickup, then
    # the lowest fret, so the choice is stable and easy to reproduce.
    def rank(sample: ToneSample) -> tuple[int, int, int, str]:
        return (sample.pickup != pickup, sample.fret, sample.string, str(sample.path))

    return min(candidates, key=rank).path


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("clean_wav", type=Path, help="Clean signal WAV to classify")
    parser.add_argument("--model", type=Path, default=Path("models/clean_pitch_knn.json"))
    parser.add_argument("--blues-dir", type=Path, default=Path("data/blues-driver"))
    args = parser.parse_args()

    classifier = load_model(args.model)
    signal = read_wav_mono(args.clean_wav)
    prediction = classifier.predict(extract_features(signal).values)
    output = matching_blues_file(prediction.label, args.blues_dir, args.clean_wav.parent.name)
    print(f"classified note: {prediction.label}")
    print(f"blues-driver file: {output}")


if __name__ == "__main__":
    main()
