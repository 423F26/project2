"""Built-in guitar pedals and click-free effect switching."""

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


class Delay:
    """Feedback delay with a fixed maximum buffer."""

    def __init__(self, sample_rate: int):
        self.sample_rate = sample_rate
        self.time = 300.0
        self.feedback = 0.35
        self.mix = 0.35
        self.buffer = np.zeros(sample_rate * 2, dtype=np.float32)
        self.position = 0

    def set_parameter(self, name: str, value: float) -> None:
        if not math.isfinite(value):
            raise ValueError("pedal setting must be finite")
        if name == "time" and 20 <= value <= 1500:
            self.time = value
        elif name == "feedback" and 0 <= value <= 0.9:
            self.feedback = value
        elif name == "mix" and 0 <= value <= 1:
            self.mix = value
        else:
            raise ValueError("invalid delay setting or value")

    def process(self, samples: np.ndarray) -> np.ndarray:
        output = np.empty(len(samples), dtype=np.float32)
        delay = max(1, round(self.time * self.sample_rate / 1000))
        size = len(self.buffer)
        for index, sample in enumerate(samples):
            dry = float(sample) / 32768.0
            wet = float(self.buffer[(self.position - delay) % size])
            output[index] = dry * (1 - self.mix) + wet * self.mix
            self.buffer[self.position] = dry + wet * self.feedback
            self.position = (self.position + 1) % size
        return _pcm16(output * 32767)


class Tremolo:
    def __init__(self, sample_rate: int):
        self.sample_rate = sample_rate
        self.rate = 5.0
        self.depth = 0.7
        self.phase = 0.0

    def set_parameter(self, name: str, value: float) -> None:
        if not math.isfinite(value):
            raise ValueError("pedal setting must be finite")
        if name == "rate" and 0.1 <= value <= 20:
            self.rate = value
        elif name == "depth" and 0 <= value <= 1:
            self.depth = value
        else:
            raise ValueError("invalid tremolo setting or value")

    def process(self, samples: np.ndarray) -> np.ndarray:
        phases = self.phase + np.arange(len(samples), dtype=np.float64) * self.rate / self.sample_rate
        gain = 1 - self.depth * (1 - np.sin(2 * np.pi * phases)) / 2
        self.phase = (self.phase + len(samples) * self.rate / self.sample_rate) % 1
        return _pcm16(samples.astype(np.float32) * gain)


class Chorus:
    """Short modulated delay mixed with the dry signal."""

    def __init__(self, sample_rate: int):
        self.sample_rate = sample_rate
        self.rate = 1.2
        self.depth = 0.5
        self.mix = 0.5
        self.phase = 0.0
        self.buffer = np.zeros(max(1, round(sample_rate * 0.06)), dtype=np.float32)
        self.position = 0

    def set_parameter(self, name: str, value: float) -> None:
        if not math.isfinite(value):
            raise ValueError("pedal setting must be finite")
        if name == "rate" and 0.1 <= value <= 5:
            self.rate = value
        elif name == "depth" and 0 <= value <= 1:
            self.depth = value
        elif name == "mix" and 0 <= value <= 1:
            self.mix = value
        else:
            raise ValueError("invalid chorus setting or value")

    def process(self, samples: np.ndarray) -> np.ndarray:
        output = np.empty(len(samples), dtype=np.float32)
        size = len(self.buffer)
        for index, sample in enumerate(samples):
            dry = float(sample) / 32768.0
            delay = (12 + 8 * self.depth * math.sin(2 * math.pi * self.phase)) * self.sample_rate / 1000
            offset = self.position - delay
            low = math.floor(offset)
            fraction = offset - low
            wet = self.buffer[low % size] * (1 - fraction) + self.buffer[(low + 1) % size] * fraction
            output[index] = dry * (1 - self.mix) + wet * self.mix
            self.buffer[self.position] = dry
            self.position = (self.position + 1) % size
            self.phase = (self.phase + self.rate / self.sample_rate) % 1
        return _pcm16(output * 32767)


BUILTIN_PEDALS = ("overdrive", "fuzz", "delay", "tremolo", "chorus")


@dataclass(frozen=True)
class PedalGraph:
    """Ordered active pedals and their directed input-to-output signal path."""

    slots: tuple[str | None, ...] = ("overdrive",)

    def __post_init__(self) -> None:
        if len(self.slots) > 32:
            raise ValueError("the board supports at most 32 pedals")
        pedals = self.pedals
        if len(set(pedals)) != len(pedals):
            raise ValueError("a pedal may appear on the board only once")
        if any(pedal not in BUILTIN_PEDALS and not pedal.startswith("lv2-") for pedal in pedals):
            raise ValueError("unknown board pedal")

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

    def __init__(self, overdrive: Overdrive, sample_rate: int, clean_level: float, fuzz: Fuzz | None = None,
                 lv2_processors: dict | None = None):
        self.sample_rate = sample_rate
        self.overdrive = overdrive
        self.fuzz = fuzz or Fuzz(sample_rate)
        self._processors = {"overdrive": self.overdrive, "fuzz": self.fuzz,
                            "delay": Delay(sample_rate), "tremolo": Tremolo(sample_rate),
                            "chorus": Chorus(sample_rate), **(lv2_processors or {})}
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

    def add_lv2_processor(self, processor) -> str:
        for key, existing in self._processors.items():
            if key.startswith("lv2-") and existing.uri == processor.uri:
                return key
        index = 1
        while f"lv2-{index}" in self._processors:
            index += 1
        key = f"lv2-{index}"
        self._processors[key] = processor
        return key

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

    def set_slots(self, slots: tuple[str | None, ...] | list[str | None]) -> None:
        self._set_graph(PedalGraph(tuple(slots)))

    def _set_graph(self, graph: PedalGraph) -> None:
        if any(pedal not in self._processors for pedal in graph.pedals):
            raise ValueError("pedal is not loaded")
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
        names = {"overdrive": ("drive", "tone", "mix", "level"),
                 "fuzz": ("drive", "tone", "level"),
                 "delay": ("time", "feedback", "mix"),
                 "tremolo": ("rate", "depth"),
                 "chorus": ("rate", "depth", "mix")}
        return {key: ({name: getattr(processor, name) for name in names[key]}
                      if key in names else processor.settings)
                for key, processor in self._processors.items()}

    @property
    def available_pedals(self) -> dict[str, dict]:
        return {name: {"name": getattr(processor, "display_name", name.title()),
                       "settings": self.settings[name],
                       "uri": getattr(processor, "uri", None),
                       "ranges": ({symbol: {"min": limits[2], "max": limits[3]}
                                   for symbol, limits in processor.controls.items()}
                                  if name.startswith("lv2-") else {})}
                for name, processor in self._processors.items()}

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
