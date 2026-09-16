from __future__ import annotations

import re
from collections import Counter
from dataclasses import dataclass
from pathlib import Path


OPEN_STRING_MIDI = {
    6: 40,  # E2
    5: 45,  # A2
    4: 50,  # D3
    3: 55,  # G3
    2: 59,  # B3
    1: 64,  # E4
}

NOTE_NAMES = ("C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B")
SAMPLE_NAME_PATTERN = re.compile(r"^(?P<string>[1-6])-(?P<fret>\d+)\.wav$", re.IGNORECASE)


@dataclass(frozen=True)
class ToneSample:
    path: Path
    pickup: str
    string: int
    fret: int
    midi: int
    note: str

    @property
    def string_fret(self) -> str:
        return f"{self.string}-{self.fret}"

    @property
    def pitch_class(self) -> str:
        return NOTE_NAMES[self.midi % 12]

    def label_for(self, target: str) -> str:
        if target == "note":
            return self.note
        if target == "midi":
            return str(self.midi)
        if target == "pitch-class":
            return self.pitch_class
        if target == "string-fret":
            return self.string_fret
        raise ValueError(f"Unsupported target: {target}")


def scan_clean_tones(clean_dir: Path) -> list[ToneSample]:
    if not clean_dir.exists():
        raise FileNotFoundError(f"clean tone directory does not exist: {clean_dir}")

    samples: list[ToneSample] = []
    for wav_path in sorted(clean_dir.glob("*/*.wav")):
        match = SAMPLE_NAME_PATTERN.match(wav_path.name)
        if match is None:
            continue

        string = int(match.group("string"))
        fret = int(match.group("fret"))
        midi = OPEN_STRING_MIDI[string] + fret
        samples.append(
            ToneSample(
                path=wav_path,
                pickup=wav_path.parent.name,
                string=string,
                fret=fret,
                midi=midi,
                note=midi_to_note(midi),
            )
        )

    if not samples:
        raise ValueError(f"No labeled WAV files found below {clean_dir}")
    return samples


def midi_to_note(midi: int) -> str:
    octave = midi // 12 - 1
    return f"{NOTE_NAMES[midi % 12]}{octave}"


def note_summary(samples: list[ToneSample], *, target: str = "note") -> Counter[str]:
    return Counter(sample.label_for(target) for sample in samples)
