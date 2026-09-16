from __future__ import annotations

import math
import wave
from dataclasses import dataclass
from pathlib import Path


@dataclass(frozen=True)
class AudioSignal:
    sample_rate: int
    samples: tuple[float, ...]


def read_wav_mono(
    path: Path,
    *,
    start_seconds: float = 0.15,
    duration_seconds: float = 1.0,
    max_sample_rate: int = 8_000,
) -> AudioSignal:
    """Read a WAV segment as mono floats, downsampling by integer decimation."""

    with wave.open(str(path), "rb") as wav_file:
        channels = wav_file.getnchannels()
        sample_width = wav_file.getsampwidth()
        sample_rate = wav_file.getframerate()
        total_frames = wav_file.getnframes()

        if channels < 1:
            raise ValueError(f"{path} has no audio channels")
        if sample_width not in (1, 2, 3, 4):
            raise ValueError(f"{path} uses unsupported sample width: {sample_width}")

        start_frame = min(max(0, int(start_seconds * sample_rate)), total_frames)
        frames_to_read = max(0, total_frames - start_frame)
        if duration_seconds > 0:
            frames_to_read = min(frames_to_read, int(duration_seconds * sample_rate))

        wav_file.setpos(start_frame)
        raw = wav_file.readframes(frames_to_read)

    stride = max(1, sample_rate // max_sample_rate)
    output_rate = sample_rate // stride
    frame_size = sample_width * channels
    samples: list[float] = []

    for frame_index in range(0, frames_to_read, stride):
        offset = frame_index * frame_size
        if offset + frame_size > len(raw):
            break
        mono_value = 0.0
        for channel in range(channels):
            sample_offset = offset + channel * sample_width
            mono_value += _decode_pcm_sample(raw, sample_offset, sample_width)
        samples.append(mono_value / channels)

    if not samples:
        raise ValueError(f"{path} did not yield any readable samples")

    return AudioSignal(sample_rate=output_rate, samples=tuple(_remove_dc(samples)))


def rms(samples: tuple[float, ...]) -> float:
    return math.sqrt(sum(sample * sample for sample in samples) / len(samples))


def zero_crossing_rate(samples: tuple[float, ...]) -> float:
    crossings = 0
    previous = samples[0]
    for sample in samples[1:]:
        if (previous < 0 <= sample) or (previous >= 0 > sample):
            crossings += 1
        previous = sample
    return crossings / max(1, len(samples) - 1)


def crest_factor(samples: tuple[float, ...]) -> float:
    level = rms(samples)
    if level == 0:
        return 0.0
    return max(abs(sample) for sample in samples) / level


def _decode_pcm_sample(raw: bytes, offset: int, sample_width: int) -> float:
    if sample_width == 1:
        return (raw[offset] - 128) / 128.0

    integer = int.from_bytes(
        raw[offset : offset + sample_width],
        byteorder="little",
        signed=True,
    )
    max_value = float(1 << (sample_width * 8 - 1))
    return integer / max_value


def _remove_dc(samples: list[float]) -> list[float]:
    mean = sum(samples) / len(samples)
    return [sample - mean for sample in samples]
