"""Local commands for the running pedal's clean/effect mode."""

from __future__ import annotations

import argparse
import json
import socket
from pathlib import Path

from ml_guitar_pedal.processing import SwitchableEffect


CONTROL_SOCKET = Path("/run/guitar-effect.sock")
MODES = ("status", "clean", "effect", "toggle")


class ModeServer:
    def __init__(self, effect: SwitchableEffect, path: Path = CONTROL_SOCKET):
        self.effect = effect
        self.path = path
        self.socket = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        try:
            path.unlink(missing_ok=True)
            self.socket.bind(str(path))
            self.socket.listen(4)
            self.socket.setblocking(False)
        except BaseException:
            self.socket.close()
            raise

    def poll(self) -> None:
        try:
            connection, _ = self.socket.accept()
        except BlockingIOError:
            return
        with connection:
            connection.settimeout(0.01)
            try:
                command = connection.recv(64).decode().strip()
                if command == "state":
                    response = self._state()
                elif command.startswith("amount "):
                    parts = command.split()
                    if len(parts) != 2:
                        raise ValueError("usage: amount <0..1>")
                    self.effect.set_amount(float(parts[1]))
                    response = self._state()
                    print(f"amount: {self.effect.amount:.2f}", flush=True)
                else:
                    response = self.effect.set_mode(command)
                    if command != "status":
                        print(f"mode: {response}", flush=True)
                connection.sendall(f"{response}\n".encode())
            except (OSError, ValueError) as error:
                try:
                    connection.sendall(f"error: {error}\n".encode())
                except OSError:
                    pass

    def _state(self) -> str:
        return json.dumps({"enabled": self.effect.enabled, "amount": self.effect.amount, "mode": self.effect.mode})

    def close(self) -> None:
        self.socket.close()
        self.path.unlink(missing_ok=True)

    def __enter__(self) -> ModeServer:
        return self

    def __exit__(self, *_exc: object) -> None:
        self.close()


def send_mode_command(command: str, path: Path = CONTROL_SOCKET) -> str:
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as client:
        client.settimeout(2)
        client.connect(str(path))
        client.sendall(command.encode())
        return client.recv(128).decode().strip()


def main(argv: list[str] | None = None) -> None:
    parser = argparse.ArgumentParser(description="Switch the running guitar effect without stopping audio.")
    parser.add_argument("mode", nargs="?", default="status", choices=MODES)
    args = parser.parse_args(argv)
    try:
        response = send_mode_command(args.mode)
    except OSError as error:
        parser.exit(1, f"pedal effect is not running: {error}\n")
    if response.startswith("error:"):
        parser.exit(1, f"{response}\n")
    print(response)
