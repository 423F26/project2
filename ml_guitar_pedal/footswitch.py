"""Toggle the running guitar effect with a switch between GPIO17 and ground."""

from __future__ import annotations

import argparse
import subprocess

from ml_guitar_pedal.control import send_mode_command


def main(argv: list[str] | None = None) -> None:
    argparse.ArgumentParser(description="Toggle clean/effect with GPIO17 and ground.").parse_args(argv)
    command = [
        "stdbuf", "-oL",
        "gpiomon",
        "--chip", "gpiochip0",
        "--bias", "pull-up",
        "--edges", "falling",
        "--debounce-period", "50ms",
        "17",
    ]
    print("footswitch: GPIO17 (physical pin 11) to GND; press to toggle", flush=True)
    with subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, bufsize=1) as monitor:
        try:
            for _event in monitor.stdout:
                try:
                    mode = send_mode_command("toggle")
                except OSError as error:
                    print(f"footswitch: effect unavailable: {error}", flush=True)
                else:
                    print(f"footswitch: {mode}", flush=True)
        except KeyboardInterrupt:
            monitor.terminate()
        finally:
            if monitor.poll() is None:
                monitor.terminate()
            monitor.wait()
        if monitor.returncode not in (0, -2, -15):
            raise RuntimeError(f"gpiomon failed: {monitor.stderr.read()}")


if __name__ == "__main__":
    main()
