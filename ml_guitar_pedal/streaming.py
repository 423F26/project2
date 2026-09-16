from __future__ import annotations

from dataclasses import dataclass
from typing import Iterable

from ml_guitar_pedal.audio import AudioSignal


@dataclass(frozen=True)
class StreamFrame:
    signal: AudioSignal
    offset_seconds: float


class StreamingFrameBuffer:
    def __init__(
        self,
        *,
        sample_rate: int,
        frame_seconds: float = 0.064,
        hop_seconds: float = 0.032,
    ) -> None:
        if frame_seconds <= 0:
            raise ValueError("frame_seconds must be positive")
        if hop_seconds <= 0:
            raise ValueError("hop_seconds must be positive")

        self.sample_rate = sample_rate
        self.frame_size = max(1, int(round(frame_seconds * sample_rate)))
        self.hop_size = max(1, int(round(hop_seconds * sample_rate)))
        self._buffer: list[float] = []
        self._buffer_start = 0
        self._samples_seen = 0
        self._next_frame_end = self.frame_size

    def push(self, samples: Iterable[float]) -> list[StreamFrame]:
        new_samples = list(samples)
        if not new_samples:
            return []

        self._buffer.extend(new_samples)
        self._samples_seen += len(new_samples)
        frames: list[StreamFrame] = []

        while self._next_frame_end <= self._samples_seen:
            frame_start = self._next_frame_end - self.frame_size
            relative_start = frame_start - self._buffer_start
            relative_end = relative_start + self.frame_size
            frame = tuple(self._buffer[relative_start:relative_end])
            frames.append(
                StreamFrame(
                    signal=AudioSignal(sample_rate=self.sample_rate, samples=frame),
                    offset_seconds=frame_start / self.sample_rate,
                )
            )
            self._next_frame_end += self.hop_size

        self._trim_buffer()
        return frames

    def _trim_buffer(self) -> None:
        keep_from = max(0, self._next_frame_end - self.frame_size)
        removable = keep_from - self._buffer_start
        if removable <= 0:
            return

        del self._buffer[:removable]
        self._buffer_start += removable


def frames_from_signal(
    signal: AudioSignal,
    *,
    frame_seconds: float = 0.064,
    hop_seconds: float = 0.032,
) -> list[StreamFrame]:
    buffer = StreamingFrameBuffer(
        sample_rate=signal.sample_rate,
        frame_seconds=frame_seconds,
        hop_seconds=hop_seconds,
    )
    return buffer.push(signal.samples)
