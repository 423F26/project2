"""Small ALSA PCM wrapper for the live pedal."""

from __future__ import annotations

import ctypes
import re
from functools import lru_cache
from pathlib import Path

import numpy as np


def available_devices() -> tuple[list[str], list[str]]:
    """List ALSA devices with capture and playback capabilities."""
    inputs: list[str] = []
    outputs: list[str] = []
    for line in Path("/proc/asound/pcm").read_text().splitlines():
        match = re.match(r"(\d+)-(\d+):", line)
        if not match:
            continue
        device = f"plughw:{int(match[1])},{int(match[2])}"
        if "capture" in line:
            inputs.append(device)
        if "playback" in line:
            outputs.append(device)
    return inputs, outputs


@lru_cache(maxsize=1)
def _alsa() -> ctypes.CDLL:
    lib = ctypes.CDLL("libasound.so.2")
    signatures = {
        "snd_pcm_open": ([ctypes.POINTER(ctypes.c_void_p), ctypes.c_char_p, ctypes.c_int, ctypes.c_int], ctypes.c_int),
        "snd_pcm_format_value": ([ctypes.c_char_p], ctypes.c_int),
        "snd_pcm_set_params": ([ctypes.c_void_p, ctypes.c_int, ctypes.c_int, ctypes.c_uint, ctypes.c_uint, ctypes.c_int, ctypes.c_uint], ctypes.c_int),
        "snd_pcm_readi": ([ctypes.c_void_p, ctypes.c_void_p, ctypes.c_ulong], ctypes.c_long),
        "snd_pcm_writei": ([ctypes.c_void_p, ctypes.c_void_p, ctypes.c_ulong], ctypes.c_long),
        "snd_pcm_recover": ([ctypes.c_void_p, ctypes.c_int, ctypes.c_int], ctypes.c_int),
        "snd_pcm_close": ([ctypes.c_void_p], ctypes.c_int),
        "snd_strerror": ([ctypes.c_int], ctypes.c_char_p),
    }
    for name, (argument_types, result_type) in signatures.items():
        function = getattr(lib, name)
        function.argtypes = argument_types
        function.restype = result_type
    return lib


class AlsaPcm:
    PLAYBACK = 0
    CAPTURE = 1

    def __init__(self, device: str, stream: int, rate: int, block: int):
        self.library = _alsa()
        self.device = device
        self.block = block
        self.recoveries = 0
        self.handle = ctypes.c_void_p()
        self._read_buffer = ctypes.create_string_buffer(block * 2)
        self._check(self.library.snd_pcm_open(ctypes.byref(self.handle), device.encode(), stream, 0))
        try:
            # plughw converts the iRig's capture format and playback channels.
            latency_us = max(10_000, int(block * 4_000_000 / rate))
            self._check(self.library.snd_pcm_set_params(
                self.handle, self.library.snd_pcm_format_value(b"S16_LE"),
                3, 1, rate, 1, latency_us,
            ))
        except BaseException:
            self.close()
            raise

    def _check(self, code: int) -> int:
        if code < 0:
            message = self.library.snd_strerror(code).decode(errors="replace")
            raise OSError(f"ALSA {self.device}: {message}")
        return code

    def read(self) -> np.ndarray:
        while True:
            count = self.library.snd_pcm_readi(self.handle, self._read_buffer, self.block)
            if count >= 0:
                return np.frombuffer(self._read_buffer.raw, dtype="<i2", count=count).copy()
            self.recoveries += 1
            self._check(self.library.snd_pcm_recover(self.handle, int(count), 1))

    def write(self, samples: np.ndarray) -> None:
        offset = 0
        while offset < len(samples):
            pointer = ctypes.c_void_p(samples.ctypes.data + offset * 2)
            count = self.library.snd_pcm_writei(self.handle, pointer, len(samples) - offset)
            if count > 0:
                offset += count
            elif count < 0:
                self.recoveries += 1
                self._check(self.library.snd_pcm_recover(self.handle, int(count), 1))

    def close(self) -> None:
        if self.handle:
            self.library.snd_pcm_close(self.handle)
            self.handle = ctypes.c_void_p()

    def __enter__(self) -> AlsaPcm:
        return self

    def __exit__(self, *_exc: object) -> None:
        self.close()
