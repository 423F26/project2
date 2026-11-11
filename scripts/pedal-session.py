"""Save and restore the manual desktop pedal's controls across launches."""
import json
import os
from pathlib import Path
import subprocess
import sys

root = Path(__file__).resolve().parent.parent
ctl = root / "build/release/pedalctl"
cache = Path(os.environ.get("XDG_CACHE_HOME", Path.home() / ".cache")) / "ml-guitar-pedal"
path = cache / "last-session.json"

def command(*arguments):
    return subprocess.check_output([str(ctl), *map(str, arguments)], text=True)

if sys.argv[1] == "save":
    state = json.loads(command("state"))
    cache.mkdir(parents=True, exist_ok=True)
    temporary = path.with_suffix(".tmp")
    temporary.write_text(json.dumps(state, indent=2) + "\n")
    temporary.replace(path)
elif sys.argv[1] == "restore" and path.exists():
    state = json.loads(path.read_text())
    # Restore the quiet control path before enabling the saved effect chain.
    command("clean")
    for name, info in state["available"].items():
        if info.get("uri"):
            command("lv2-load", info["uri"])
        for setting, value in state["settings"][name].items():
            command("config", name, setting, value)
        command("bypass", name, "on" if info.get("bypassed") else "off")
    command("board", ",".join(state["pedals"]) or "-")
    command("amount", state["amount"])
    command("tuner", "on" if state["tuner"]["enabled"] else "off")
    binding = state.get("encoder", {})
    if binding.get("pedal") and binding.get("parameter"):
        try:
            command("encoder", "assign", binding["pedal"], binding["parameter"])
        except subprocess.CalledProcessError:
            print("Saved encoder target is unavailable; assign it again in pedal settings.", file=sys.stderr)
    command("effect" if state["enabled"] else "clean")
