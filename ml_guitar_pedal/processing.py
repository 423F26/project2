"""Guitar overdrive, fuzz, and click-free effect switching."""

from __future__ import annotations

import math
from copy import deepcopy
from dataclasses import dataclass

import numpy as np


def _pcm16(samples: np.ndarray) -> np.ndarray:
    return np.clip(np.rint(samples), -32768, 32767).astype("<i2")


class Overdrive:
    def __init__(self, sample_rate: int, drive: float, tone: float, mix: float, level: float):
        self.sample_rate = sample_rate
        self.drive = drive
        self.tone = tone
        self.mix = mix
        self.level = level
        self.alpha = 1.0 - math.exp(-2.0 * math.pi * tone / sample_rate)
        self.filter_state = 0.0
        self.normalization = math.tanh(drive)

    def set_parameter(self, name: str, value: float) -> None:
        if not math.isfinite(value):
            raise ValueError("pedal setting must be finite")
        if name == "drive" and 1.0 <= value <= 100.0:
            self.drive = value
            self.normalization = math.tanh(value)
        elif name == "tone" and 100.0 <= value < self.sample_rate / 2:
            self.tone = value
            self.alpha = 1.0 - math.exp(-2.0 * math.pi * value / self.sample_rate)
        elif name == "mix" and 0.0 <= value <= 1.0:
            self.mix = value
        elif name == "level" and 0.0 <= value <= 1.0:
            self.level = value
        else:
            raise ValueError("invalid overdrive setting or value")

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


class Fuzz:
    """Hard clipping followed by a one-pole tone filter."""

    def __init__(self, sample_rate: int, drive: float = 15.0, tone: float = 2_500.0, level: float = 0.45):
        self.sample_rate = sample_rate
        self.drive = drive
        self.tone = tone
        self.level = level
        self.alpha = 1.0 - math.exp(-2.0 * math.pi * tone / sample_rate)
        self.filter_state = 0.0

    def set_parameter(self, name: str, value: float) -> None:
        if not math.isfinite(value):
            raise ValueError("pedal setting must be finite")
        if name == "drive" and 1.0 <= value <= 100.0:
            self.drive = value
        elif name == "tone" and 100.0 <= value < self.sample_rate / 2:
            self.tone = value
            self.alpha = 1.0 - math.exp(-2.0 * math.pi * value / self.sample_rate)
        elif name == "level" and 0.0 <= value <= 1.0:
            self.level = value
        else:
            raise ValueError("invalid fuzz setting or value")

    def process(self, samples: np.ndarray) -> np.ndarray:
        signal = samples.astype(np.float32) / 32768.0
        clipped = np.clip(signal * self.drive, -0.35, 0.35) / 0.35
        filtered = np.empty_like(clipped)
        state = self.filter_state
        for index, value in enumerate(clipped):
            state += self.alpha * (float(value) - state)
            filtered[index] = state
        self.filter_state = state
        return _pcm16(filtered * self.level * 32767.0)


@dataclass(frozen=True)
class PedalGraph:
    """Two physical slots and their directed input-to-output signal path."""

    slots: tuple[str | None, ...] = ("overdrive", None)

    def __post_init__(self) -> None:
        if len(self.slots) > 2:
            raise ValueError("the board has two slots")
        object.__setattr__(self, "slots", (*self.slots, *(None for _ in range(2 - len(self.slots)))))
        pedals = self.pedals
        if len(set(pedals)) != len(pedals):
            raise ValueError("a pedal may appear on the board only once")
        if any(pedal not in ("overdrive", "fuzz") for pedal in pedals):
            raise ValueError("board pedals must be overdrive or fuzz")

    @property
    def pedals(self) -> tuple[str, ...]:
        return tuple(pedal for pedal in self.slots if pedal is not None)

    @property
    def nodes(self) -> tuple[str, ...]:
        return ("input", *self.pedals, "output")

    @property
    def edges(self) -> tuple[tuple[str, str], ...]:
        return tuple(zip(self.nodes, self.nodes[1:]))


class SwitchableEffect:
    """Process a serial pedal graph with click-free board and bypass changes."""

    def __init__(self, overdrive: Overdrive, sample_rate: int, clean_level: float, fuzz: Fuzz | None = None):
        self.overdrive = overdrive
        self.fuzz = fuzz or Fuzz(sample_rate)
        self._processors = {"overdrive": self.overdrive, "fuzz": self.fuzz}
        self.graph = PedalGraph()
        self._previous_graph: PedalGraph | None = None
        self._previous_processors: dict | None = None
        self.graph_wet = 1.0
        self.clean_level = clean_level
        self.enabled = True
        self.amount = 1.0
        self.wet = 1.0
        self.target = 1.0
        self.fade_samples = max(1, sample_rate // 100)  # 10 ms

    @property
    def mode(self) -> str:
        return "effect" if self.enabled else "clean"

    @property
    def effect_type(self) -> str:
        """Legacy single-effect view for older control clients."""
        return self.graph.pedals[-1] if self.graph.pedals else "overdrive"

    def set_amount(self, amount: float) -> None:
        if not math.isfinite(amount) or not 0.0 <= amount <= 1.0:
            raise ValueError("amount must be between 0 and 1")
        self.amount = amount
        self.target = amount if self.enabled else 0.0

    def set_effect_type(self, effect_type: str) -> None:
        self.set_board((effect_type,))

    def set_board(self, pedals: tuple[str, ...] | list[str]) -> None:
        self._set_graph(PedalGraph(tuple(pedals)))

    def set_slots(self, slots: tuple[str | None, str | None] | list[str | None]) -> None:
        if len(slots) != 2:
            raise ValueError("board requires exactly two slots")
        self._set_graph(PedalGraph(tuple(slots)))

    def _set_graph(self, graph: PedalGraph) -> None:
        if graph == self.graph:
            return
        if graph.pedals == self.graph.pedals:
            self.graph = graph
            return
        if not self.enabled and self.wet == 0.0:
            self.graph = graph
            self._previous_graph = None
            self._previous_processors = None
            self.graph_wet = 1.0
            return
        self._previous_graph = self.graph
        self._previous_processors = deepcopy(self._processors)
        self.graph = graph
        self.graph_wet = 0.0

    def set_pedal_config(self, pedal: str, name: str, value: float) -> None:
        if pedal not in self._processors:
            raise ValueError("unknown pedal")
        processor = self._processors[pedal]
        # Validate on a copy before starting the audible graph transition.
        updated = deepcopy(processor)
        updated.set_parameter(name, value)
        if pedal in self.graph.pedals and self.wet > 0.0:
            self._previous_graph = self.graph
            self._previous_processors = deepcopy(self._processors)
            self.graph_wet = 0.0
        processor.set_parameter(name, value)

    @property
    def settings(self) -> dict[str, dict[str, float]]:
        return {
            "overdrive": {"drive": self.overdrive.drive, "tone": self.overdrive.tone,
                          "mix": self.overdrive.mix, "level": self.overdrive.level},
            "fuzz": {"drive": self.fuzz.drive, "tone": self.fuzz.tone,
                     "level": self.fuzz.level},
        }

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

    def _process_graph(self, graph: PedalGraph, processors: dict, samples: np.ndarray) -> np.ndarray:
        if not graph.pedals:
            return _pcm16(samples.astype(np.float32) * self.clean_level)
        signal = samples
        for pedal in graph.pedals:
            signal = processors[pedal].process(signal)
        return signal

    def process(self, samples: np.ndarray) -> np.ndarray:
        if len(samples) == 0:
            return samples.copy()
        clean = samples.astype(np.float32) * self.clean_level
        if self.wet == self.target == 0.0:
            return _pcm16(clean)
        if self._previous_graph is None and self.wet == self.target == 1.0:
            return self._process_graph(self.graph, self._processors, samples)

        dirty = self._process_graph(self.graph, self._processors, samples).astype(np.float32)
        if self._previous_graph is not None:
            old = self._process_graph(self._previous_graph, self._previous_processors, samples).astype(np.float32)
            graph_blend = self._advance("graph_wet", 1.0, len(samples))
            dirty = old * (1.0 - graph_blend) + dirty * graph_blend
            if self.graph_wet == 1.0:
                self._previous_graph = None
                self._previous_processors = None

        blend = self._advance("wet", self.target, len(samples))
        return _pcm16(clean * (1.0 - blend) + dirty * blend)

    def _advance(self, field: str, target: float, count: int) -> float | np.ndarray:
        current = getattr(self, field)
        if current == target:
            return target
        step = np.arange(1, count + 1, dtype=np.float32) / self.fade_samples
        if target > current:
            blend = np.minimum(current + step, target)
        else:
            blend = np.maximum(current - step, target)
        end = float(blend[-1])
        setattr(self, field, target if abs(end - target) < 1e-6 else end)
        return blend
