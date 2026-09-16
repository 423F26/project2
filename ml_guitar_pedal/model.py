from __future__ import annotations

import json
import math
from collections import Counter, defaultdict
from dataclasses import dataclass
from pathlib import Path
from random import Random
from typing import Iterable

from ml_guitar_pedal.features import FEATURE_NAMES

FEATURE_WEIGHTS = (30.0, 2.0, 0.5, 0.25, 0.5, 0.25, 0.15, 0.15, 0.15, 0.15)
DEFAULT_PROTOTYPE_LABELS = 5


@dataclass(frozen=True)
class TrainingExample:
    label: str
    features: tuple[float, ...]
    path: str
    pickup: str
    note: str
    midi: int
    string: int
    fret: int


@dataclass(frozen=True)
class Prediction:
    label: str
    votes: tuple[tuple[str, int], ...]
    distance: float


@dataclass(frozen=True)
class LabelPrototype:
    label: str
    features: tuple[float, ...]
    count: int


class KnnPitchClassifier:
    def __init__(self, *, k: int = 5, prototype_labels: int = DEFAULT_PROTOTYPE_LABELS) -> None:
        if k < 1:
            raise ValueError("k must be at least 1")
        if prototype_labels < 1:
            raise ValueError("prototype_labels must be at least 1")
        self.k = k
        self.prototype_labels = prototype_labels
        self.means: tuple[float, ...] = ()
        self.scales: tuple[float, ...] = ()
        self.examples: tuple[TrainingExample, ...] = ()
        self.prototypes: tuple[LabelPrototype, ...] = ()
        self._scaled_examples: tuple[tuple[float, ...], ...] = ()
        self._scaled_prototypes: tuple[tuple[float, ...], ...] = ()

    def fit(self, examples: Iterable[TrainingExample]) -> None:
        self.examples = tuple(examples)
        if not self.examples:
            raise ValueError("Cannot train without examples")

        feature_count = len(self.examples[0].features)
        if feature_count != len(FEATURE_NAMES):
            raise ValueError("Feature vector does not match classifier feature names")

        columns = [[example.features[index] for example in self.examples] for index in range(feature_count)]
        self.means = tuple(sum(column) / len(column) for column in columns)
        self.scales = tuple(_standard_deviation(column, mean) or 1.0 for column, mean in zip(columns, self.means))
        self._refresh_indexes()

    def predict(self, features: tuple[float, ...]) -> Prediction:
        if not self.examples:
            raise ValueError("Classifier has not been trained")

        scaled = self._scale(features)
        neighbors = self._nearest_neighbors(scaled)

        votes = Counter(example.label for _, example in neighbors)
        scores: defaultdict[str, float] = defaultdict(float)
        nearest_distance_by_label: dict[str, float] = {}
        for distance_squared, example in neighbors:
            distance = math.sqrt(distance_squared)
            scores[example.label] += 1.0 / (distance + 1e-9)
            nearest_distance_by_label[example.label] = min(
                nearest_distance_by_label.get(example.label, float("inf")),
                distance,
            )

        label = min(
            scores,
            key=lambda candidate: (-scores[candidate], nearest_distance_by_label[candidate], candidate),
        )
        return Prediction(
            label=label,
            votes=tuple(votes.most_common()),
            distance=math.sqrt(neighbors[0][0]),
        )

    def to_json(self) -> dict[str, object]:
        return {
            "version": 1,
            "k": self.k,
            "prototype_labels": self.prototype_labels,
            "feature_names": list(FEATURE_NAMES),
            "feature_weights": list(FEATURE_WEIGHTS),
            "means": list(self.means),
            "scales": list(self.scales),
            "prototypes": [
                {
                    "label": prototype.label,
                    "features": list(prototype.features),
                    "count": prototype.count,
                }
                for prototype in self.prototypes
            ],
            "examples": [
                {
                    "label": example.label,
                    "features": list(example.features),
                    "path": example.path,
                    "pickup": example.pickup,
                    "note": example.note,
                    "midi": example.midi,
                    "string": example.string,
                    "fret": example.fret,
                }
                for example in self.examples
            ],
        }

    @classmethod
    def from_json(cls, payload: dict[str, object]) -> "KnnPitchClassifier":
        feature_names = tuple(payload.get("feature_names", ()))
        if feature_names != FEATURE_NAMES:
            raise ValueError("Model feature names do not match this code version")

        classifier = cls(
            k=int(payload["k"]),
            prototype_labels=int(payload.get("prototype_labels", DEFAULT_PROTOTYPE_LABELS)),
        )
        classifier.means = tuple(float(value) for value in payload["means"])  # type: ignore[index]
        classifier.scales = tuple(float(value) for value in payload["scales"])  # type: ignore[index]
        classifier.examples = tuple(
            TrainingExample(
                label=str(example["label"]),
                features=tuple(float(value) for value in example["features"]),
                path=str(example["path"]),
                pickup=str(example["pickup"]),
                note=str(example["note"]),
                midi=int(example["midi"]),
                string=int(example["string"]),
                fret=int(example["fret"]),
            )
            for example in payload["examples"]  # type: ignore[index]
        )
        prototypes = payload.get("prototypes")
        if prototypes:
            classifier.prototypes = tuple(
                LabelPrototype(
                    label=str(prototype["label"]),
                    features=tuple(float(value) for value in prototype["features"]),
                    count=int(prototype["count"]),
                )
                for prototype in prototypes  # type: ignore[union-attr]
            )
        classifier._refresh_indexes(rebuild_prototypes=not bool(prototypes))
        return classifier

    def _scale(self, features: tuple[float, ...]) -> tuple[float, ...]:
        return tuple(
            ((value - mean) / scale) * weight
            for value, mean, scale, weight in zip(features, self.means, self.scales, FEATURE_WEIGHTS)
        )

    def _nearest_neighbors(self, scaled_features: tuple[float, ...]) -> list[tuple[float, TrainingExample]]:
        candidate_labels = self._candidate_labels(scaled_features)
        candidates = [
            (index, example)
            for index, example in enumerate(self.examples)
            if example.label in candidate_labels
        ]
        if len(candidates) < self.k:
            candidates = list(enumerate(self.examples))

        return sorted(
            (
                (_squared_distance(scaled_features, self._scaled_examples[index]), example)
                for index, example in candidates
            ),
            key=lambda item: item[0],
        )[: self.k]

    def _candidate_labels(self, scaled_features: tuple[float, ...]) -> set[str]:
        if not self.prototypes:
            return {example.label for example in self.examples}

        top_count = min(len(self.prototypes), max(self.k, self.prototype_labels))
        nearest_prototypes = sorted(
            (
                (_squared_distance(scaled_features, scaled_prototype), prototype.label)
                for prototype, scaled_prototype in zip(self.prototypes, self._scaled_prototypes)
            ),
            key=lambda item: item[0],
        )[:top_count]
        return {label for _, label in nearest_prototypes}

    def _refresh_indexes(self, *, rebuild_prototypes: bool = True) -> None:
        if rebuild_prototypes:
            self.prototypes = self._build_prototypes()
        self._scaled_examples = tuple(self._scale(example.features) for example in self.examples)
        self._scaled_prototypes = tuple(self._scale(prototype.features) for prototype in self.prototypes)

    def _build_prototypes(self) -> tuple[LabelPrototype, ...]:
        by_label: defaultdict[str, list[TrainingExample]] = defaultdict(list)
        for example in self.examples:
            by_label[example.label].append(example)

        prototypes: list[LabelPrototype] = []
        for label, examples in sorted(by_label.items()):
            feature_count = len(examples[0].features)
            features = tuple(
                sum(example.features[index] for example in examples) / len(examples)
                for index in range(feature_count)
            )
            prototypes.append(LabelPrototype(label=label, features=features, count=len(examples)))
        return tuple(prototypes)


def train_test_split(
    examples: list[TrainingExample],
    *,
    test_size: float = 0.2,
    seed: int = 13,
) -> tuple[list[TrainingExample], list[TrainingExample]]:
    if not 0.0 < test_size < 1.0:
        raise ValueError("test_size must be between 0 and 1")

    random = Random(seed)
    by_label: defaultdict[str, list[TrainingExample]] = defaultdict(list)
    for example in examples:
        by_label[example.label].append(example)

    train: list[TrainingExample] = []
    test: list[TrainingExample] = []
    for group in by_label.values():
        shuffled = group[:]
        random.shuffle(shuffled)
        if len(shuffled) == 1:
            train.extend(shuffled)
            continue

        test_count = max(1, int(round(len(shuffled) * test_size)))
        test_count = min(test_count, len(shuffled) - 1)
        test.extend(shuffled[:test_count])
        train.extend(shuffled[test_count:])

    random.shuffle(train)
    random.shuffle(test)
    return train, test


def save_model(classifier: KnnPitchClassifier, path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(classifier.to_json(), indent=2), encoding="utf-8")


def load_model(path: Path) -> KnnPitchClassifier:
    return KnnPitchClassifier.from_json(json.loads(path.read_text(encoding="utf-8")))


def accuracy(classifier: KnnPitchClassifier, examples: Iterable[TrainingExample]) -> tuple[int, int, float]:
    total = 0
    correct = 0
    for example in examples:
        total += 1
        if classifier.predict(example.features).label == example.label:
            correct += 1
    return correct, total, correct / total if total else 0.0


def _standard_deviation(values: list[float], mean: float) -> float:
    variance = sum((value - mean) ** 2 for value in values) / len(values)
    return math.sqrt(variance)


def _squared_distance(left: tuple[float, ...], right: tuple[float, ...]) -> float:
    return sum((left_value - right_value) ** 2 for left_value, right_value in zip(left, right))
