"""Python command-line client for the native pedal engine's Unix socket."""

from __future__ import annotations

import argparse
import os
import socket
from pathlib import Path


CONTROL_SOCKET = Path(os.environ.get("PEDAL_CONTROL_SOCKET", "/run/guitar-effect.sock"))
MODES = ("status", "clean", "effect", "toggle", "overdrive", "fuzz", "delay", "tremolo", "chorus")


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
    parser = argparse.ArgumentParser(description="Control the running native pedal without stopping audio.")
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


if __name__ == "__main__":
    main()
