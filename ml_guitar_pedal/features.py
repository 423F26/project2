from __future__ import annotations

import math
from dataclasses import dataclass
from typing import Sequence

import numpy as np

from ml_guitar_pedal.audio import AudioSignal


FEATURE_NAMES = (
    "estimated_midi",
    "cents_from_nearest",
    "yin_confidence",
    "log_rms",
    "zero_crossing_rate",
    "crest_factor",
    "harmonic_1",
    "harmonic_2",
    "harmonic_3",
    "harmonic_4",
)


@dataclass(frozen=True)
class ExtractedFeatures:
    values: tuple[float, ...]
    estimated_hz: float
    estimated_note_midi: int
    confidence: float


def extract_features(signal: AudioSignal) -> ExtractedFeatures:
    samples = _as_array(signal.samples)
    frequency_hz, confidence = estimate_fundamental_yin(samples, signal.sample_rate)
    frequency_hz, harmonic_features = corrected_frequency_and_harmonics(samples, signal.sample_rate, frequency_hz)
    midi_value = frequency_to_midi(frequency_hz)
    nearest_midi = int(round(midi_value))
    cents_from_nearest = (midi_value - nearest_midi) * 100.0
    level = max(_rms(samples), 1e-12)

    values = (
        midi_value,
        cents_from_nearest / 50.0,
        confidence,
        math.log(level),
        _zero_crossing_rate(samples),
        _crest_factor(samples, level),
        *harmonic_features,
    )
    return ExtractedFeatures(
        values=values,
        estimated_hz=frequency_hz,
        estimated_note_midi=nearest_midi,
        confidence=confidence,
    )


def estimate_fundamental_yin(
    samples: Sequence[float] | np.ndarray,
    sample_rate: int,
    *,
    min_frequency: float = 60.0,
    max_frequency: float = 1_400.0,
    threshold: float = 0.12,
) -> tuple[float, float]:
    """Estimate f0 using a compact YIN-style difference function."""

    samples_array = _as_array(samples)
    if len(samples_array) < 32:
        raise ValueError("Not enough samples to estimate pitch")

    analysis = _analysis_window(samples_array, max_size=4_096)
    max_lag = min(int(sample_rate / min_frequency), len(analysis) // 2)
    min_lag = max(2, int(sample_rate / max_frequency))
    if max_lag <= min_lag:
        raise ValueError("Pitch range is not compatible with this sample rate/window")

    differences = np.zeros(max_lag + 1, dtype=np.float64)
    for lag in range(1, max_lag + 1):
        delta = analysis[:-lag] - analysis[lag:]
        differences[lag] = float(np.dot(delta, delta))

    cumulative = np.cumsum(differences)
    normalized = np.ones(max_lag + 1, dtype=np.float64)
    valid_lags = np.flatnonzero(cumulative[1:] > 0) + 1
    normalized[valid_lags] = differences[valid_lags] * valid_lags / cumulative[valid_lags]

    best_lag = int(np.argmin(normalized[min_lag : max_lag + 1]) + min_lag)
    chosen_lag = best_lag
    threshold_region = normalized[min_lag:max_lag]
    falling_region = normalized[min_lag + 1 : max_lag + 1]
    threshold_hits = np.flatnonzero((threshold_region < threshold) & (threshold_region <= falling_region))
    if len(threshold_hits) > 0:
        chosen_lag = int(threshold_hits[0] + min_lag)
        while chosen_lag + 1 <= max_lag and normalized[chosen_lag + 1] < normalized[chosen_lag]:
            chosen_lag += 1

    refined_lag = _parabolic_lag(normalized, chosen_lag)
    frequency = sample_rate / refined_lag
    confidence = max(0.0, min(1.0, 1.0 - normalized[chosen_lag]))
    return frequency, confidence


def correct_octave_from_even_harmonics(
    samples: Sequence[float] | np.ndarray,
    sample_rate: int,
    frequency_hz: float,
    *,
    max_frequency: float = 1_400.0,
    dominance_threshold: float = 7.0,
) -> float:
    """Correct octave-low estimates where even harmonics dominate the odd harmonics."""

    frequency_hz, _ = corrected_frequency_and_harmonics(
        samples,
        sample_rate,
        frequency_hz,
        max_frequency=max_frequency,
        dominance_threshold=dominance_threshold,
    )
    return frequency_hz


def corrected_frequency_and_harmonics(
    samples: Sequence[float] | np.ndarray,
    sample_rate: int,
    frequency_hz: float,
    *,
    max_frequency: float = 1_400.0,
    dominance_threshold: float = 7.0,
) -> tuple[float, tuple[float, ...]]:
    samples_array = _as_array(samples)
    harmonic_features = harmonic_profile(samples_array, sample_rate, frequency_hz)
    doubled_frequency = frequency_hz * 2.0
    if doubled_frequency > max_frequency or doubled_frequency >= sample_rate / 2:
        return frequency_hz, harmonic_features

    harmonic_1, harmonic_2, harmonic_3, harmonic_4 = harmonic_features
    even_harmonics_dominate = (
        harmonic_2 - harmonic_1 > dominance_threshold
        and harmonic_4 - harmonic_3 > dominance_threshold
    )
    if even_harmonics_dominate:
        return doubled_frequency, harmonic_profile(samples_array, sample_rate, doubled_frequency)
    return frequency_hz, harmonic_features


def frequency_to_midi(frequency_hz: float) -> float:
    if frequency_hz <= 0:
        return 0.0
    return 69.0 + 12.0 * math.log2(frequency_hz / 440.0)


def harmonic_profile(
    samples: Sequence[float] | np.ndarray,
    sample_rate: int,
    fundamental_hz: float,
    *,
    harmonics: int = 4,
) -> tuple[float, ...]:
    samples_array = _as_array(samples)
    powers = []
    for harmonic in range(1, harmonics + 1):
        frequency = fundamental_hz * harmonic
        if frequency >= sample_rate / 2:
            powers.append(1e-12)
        else:
            powers.append(max(_frequency_power(samples_array, sample_rate, frequency), 1e-12))

    total = sum(powers)
    return tuple(math.log(power / total) for power in powers)


def _as_array(samples: Sequence[float] | np.ndarray) -> np.ndarray:
    if isinstance(samples, np.ndarray):
        return samples.astype(np.float64, copy=False)
    return np.asarray(samples, dtype=np.float64)


def _analysis_window(samples: np.ndarray, *, max_size: int) -> np.ndarray:
    if len(samples) <= max_size:
        window = samples
    else:
        start = max(0, len(samples) // 2 - max_size // 2)
        window = samples[start : start + max_size]

    return window - float(np.mean(window))


def _parabolic_lag(values: Sequence[float] | np.ndarray, lag: int) -> float:
    if lag <= 1 or lag >= len(values) - 1:
        return float(lag)

    previous_value = values[lag - 1]
    center_value = values[lag]
    next_value = values[lag + 1]
    denominator = previous_value - 2.0 * center_value + next_value
    if denominator == 0:
        return float(lag)
    adjustment = 0.5 * (previous_value - next_value) / denominator
    return max(1.0, lag + adjustment)


def _frequency_power(samples: np.ndarray, sample_rate: int, frequency_hz: float) -> float:
    indexes = np.arange(len(samples), dtype=np.float64)
    angles = 2.0 * math.pi * frequency_hz * indexes / sample_rate
    real = float(np.dot(samples, np.cos(angles)))
    imaginary = float(np.dot(samples, np.sin(angles)))
    return real * real + imaginary * imaginary


def _rms(samples: np.ndarray) -> float:
    return float(np.sqrt(np.mean(samples * samples)))


def _zero_crossing_rate(samples: np.ndarray) -> float:
    if len(samples) < 2:
        return 0.0
    crossings = int(np.count_nonzero(np.signbit(samples[1:]) != np.signbit(samples[:-1])))
    return crossings / (len(samples) - 1)


def _crest_factor(samples: np.ndarray, level: float) -> float:
    if level == 0:
        return 0.0
    return float(np.max(np.abs(samples)) / level)
