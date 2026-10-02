"""Guitar overdrive and click-free clean/effect switching."""

from __future__ import annotations

import math

import numpy as np


def _pcm16(samples: np.ndarray) -> np.ndarray:
    return np.clip(np.rint(samples), -32768, 32767).astype("<i2")


class Overdrive:
    def __init__(self, sample_rate: int, drive: float, tone: float, mix: float, level: float):
        self.drive = drive
        self.mix = mix
        self.level = level
        self.alpha = 1.0 - math.exp(-2.0 * math.pi * tone / sample_rate)
        self.filter_state = 0.0
        self.normalization = math.tanh(drive)

    def process(self, samples: np.ndarray) -> np.ndarray:
        signal = samples.astype(np.float32) / 32768.0
        distorted = np.tanh(signal * self.drive) / self.normalization
        filtered = np.empty_like(distorted)
        state = self.filter_state
        for index, value in enumerate(distorted):
            state += self.alpha * (float(value) - state)
            filtered[index] = state
        self.filter_state = state
        output = ((1.0 - self.mix) * signal + self.mix * filtered) * self.level
        return _pcm16(output * 32767.0)


class SwitchableEffect:
    """Crossfade between clean input and overdrive without reopening ALSA."""

    def __init__(self, overdrive: Overdrive, sample_rate: int, clean_level: float):
        self.overdrive = overdrive
        self.clean_level = clean_level
        self.enabled = True
        self.amount = 1.0
        self.wet = 1.0
        self.target = 1.0
        self.fade_samples = max(1, sample_rate // 100)  # 10 ms

    @property
    def mode(self) -> str:
        return "effect" if self.enabled else "clean"

    def set_amount(self, amount: float) -> None:
        if not math.isfinite(amount) or not 0.0 <= amount <= 1.0:
            raise ValueError("amount must be between 0 and 1")
        self.amount = amount
        self.target = amount if self.enabled else 0.0

    def set_mode(self, command: str) -> str:
        if command == "toggle":
            self.enabled = not self.enabled
        elif command == "clean":
            self.enabled = False
        elif command == "effect":
            self.enabled = True
        elif command != "status":
            raise ValueError("mode must be clean, effect, toggle, or status")
        self.target = self.amount if self.enabled else 0.0
        return self.mode

    def process(self, samples: np.ndarray) -> np.ndarray:
        if self.wet == self.target == 1.0:
            return self.overdrive.process(samples)
        clean = samples.astype(np.float32) * self.clean_level
        if self.wet == self.target == 0.0:
            return _pcm16(clean)
        dirty = self.overdrive.process(samples).astype(np.float32)
        if self.target == self.wet:
            blend = self.target
        else:
            step = np.arange(1, len(samples) + 1, dtype=np.float32) / self.fade_samples
            if self.target > self.wet:
                blend = np.minimum(self.wet + step, self.target)
            else:
                blend = np.maximum(self.wet - step, self.target)
            self.wet = float(blend[-1])
            if abs(self.wet - self.target) < 1e-6:
                self.wet = self.target
        return _pcm16(clean * (1.0 - blend) + dirty * blend)
