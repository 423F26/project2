"""Local commands for the running pedal's mode and effect selection."""

from __future__ import annotations

import argparse
import json
import socket
from pathlib import Path

from ml_guitar_pedal.processing import BUILTIN_PEDALS, SwitchableEffect


CONTROL_SOCKET = Path("/run/guitar-effect.sock")
MODES = ("status", "clean", "effect", "toggle", *BUILTIN_PEDALS)


class ModeServer:
    def __init__(self, effect: SwitchableEffect, path: Path = CONTROL_SOCKET, lv2_world=None):
        self.effect = effect
        self.path = path
        self.lv2_world = lv2_world
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
                command = connection.recv(4096).decode().strip()
                if command == "state":
                    response = self._state()
                elif command == "lv2-list":
                    loaded = {processor.uri: key for key, processor in self.effect._processors.items()
                              if key.startswith("lv2-")}
                    response = json.dumps({"plugins": [
                        {"uri": uri, "name": name, "loaded_as": loaded.get(uri)}
                        for uri, name in self._lv2_world().available()
                    ]})
                elif command.startswith("lv2-load "):
                    uri = command[9:]
                    if not uri or any(character.isspace() for character in uri):
                        raise ValueError("a valid LV2 plugin URI is required")
                    from ml_guitar_pedal.lv2_host import LV2Processor
                    existing = next((key for key, processor in self.effect._processors.items()
                                     if key.startswith("lv2-") and processor.uri == uri), None)
                    if existing is None:
                        processor = LV2Processor(self._lv2_world(), uri, self.effect.sample_rate)
                        existing = self.effect.add_lv2_processor(processor)
                        print(f"loaded LV2 effect: {processor.display_name} as {existing}", flush=True)
                    response = self._state()
                elif command.startswith("amount "):
                    parts = command.split()
                    if len(parts) != 2:
                        raise ValueError("usage: amount <0..1>")
                    self.effect.set_amount(float(parts[1]))
                    response = self._state()
                    print(f"amount: {self.effect.amount:.2f}", flush=True)
                elif command.startswith("board "):
                    members = command[6:]
                    pedals = () if members == "-" else tuple(members.split(","))
                    self.effect.set_board(pedals)
                    response = self._state()
                    print(f"board: {' -> '.join(self.effect.graph.nodes)}", flush=True)
                elif command.startswith("slots "):
                    members = command[6:].split(",")
                    self.effect.set_slots(tuple(None if member == "-" else member for member in members))
                    response = self._state()
                    print(f"slots: {self.effect.graph.slots}", flush=True)
                elif command.startswith("config "):
                    parts = command.split()
                    if len(parts) != 4:
                        raise ValueError("usage: config <pedal> <setting> <value>")
                    self.effect.set_pedal_config(parts[1], parts[2], float(parts[3]))
                    response = self._state()
                    print(f"config: {parts[1]} {parts[2]} {parts[3]}", flush=True)
                elif command in self.effect.available_pedals:
                    self.effect.set_effect_type(command)
                    response = self._state()
                    print(f"effect type: {command}", flush=True)
                else:
                    response = self.effect.set_mode(command)
                    if command != "status":
                        print(f"mode: {response}", flush=True)
                connection.sendall(f"{response}\n".encode())
            except (OSError, ValueError, RuntimeError) as error:
                try:
                    connection.sendall(f"error: {error}\n".encode())
                except OSError:
                    pass

    def _state(self) -> str:
        graph = self.effect.graph
        return json.dumps({
            "enabled": self.effect.enabled,
            "amount": self.effect.amount,
            "mode": self.effect.mode,
            "effect_type": self.effect.effect_type,
            "pedals": graph.pedals,
            "slots": graph.slots,
            "settings": self.effect.settings,
            "available": self.effect.available_pedals,
            "graph": {"nodes": graph.nodes, "edges": graph.edges},
        })

    def _lv2_world(self):
        if self.lv2_world is None:
            from ml_guitar_pedal.lv2_host import LV2World
            self.lv2_world = LV2World()
        return self.lv2_world

    def close(self) -> None:
        self.socket.close()
        self.path.unlink(missing_ok=True)

    def __enter__(self) -> ModeServer:
        return self

    def __exit__(self, *_exc: object) -> None:
        self.close()


def send_mode_command(command: str, path: Path = CONTROL_SOCKET) -> str:
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as client:
        client.settimeout(15 if command.startswith("lv2-") else 2)
        client.connect(str(path))
        client.sendall(command.encode())
        chunks = []
        while True:
            chunk = client.recv(4096)
            if not chunk:
                break
            chunks.append(chunk)
            if b"\n" in chunk:
                break
        return b"".join(chunks).decode().strip()


def main(argv: list[str] | None = None) -> None:
    parser = argparse.ArgumentParser(description="Switch clean/effect mode or edit the pedal board without stopping audio.")
    parser.add_argument("mode", nargs="?", default="status", choices=(*MODES, "board", "slots", "config"))
    parser.add_argument("arguments", nargs="*", help="Board order, slot contents, or pedal setting")
    args = parser.parse_args(argv)
    if args.mode in ("board", "slots"):
        if len(args.arguments) != 1:
            parser.error(f"{args.mode} requires one comma-separated list")
        command = f"{args.mode} {args.arguments[0]}"
    elif args.mode == "config":
        if len(args.arguments) != 3:
            parser.error("config requires pedal, setting, and value")
        command = f"config {' '.join(args.arguments)}"
    else:
        if args.arguments:
            parser.error(f"{args.mode} takes no additional arguments")
        command = args.mode
    try:
        response = send_mode_command(command)
    except OSError as error:
        parser.exit(1, f"pedal effect is not running: {error}\n")
    if response.startswith("error:"):
        parser.exit(1, f"{response}\n")
    print(response)
