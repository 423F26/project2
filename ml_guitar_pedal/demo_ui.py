"""Small localhost browser control for the running guitar pedal."""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
import time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

from ml_guitar_pedal.control import send_mode_command


PAGE = """<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Guitar Pedal Board</title>
<style>
  :root { color-scheme: dark; font-family: system-ui, sans-serif; }
  body { margin: 0; min-height: 100vh; display: grid; place-items: center; background: #11171c; color: #eef5f3; }
  main { box-sizing: border-box; width: min(440px, calc(100% - 32px)); padding: 28px; border: 1px solid #34444b; border-radius: 20px; background: #1d282e; box-shadow: 0 20px 60px #0005; }
  h1 { margin: 0 0 6px; font-size: 1.65rem; }
  p { color: #b6c7c8; margin: 0 0 26px; }
  button { width: 100%; min-height: 88px; border: 0; border-radius: 15px; background: #20c68a; color: #082c25; font: 700 1.55rem system-ui; cursor: pointer; }
  button.clean { background: #637782; color: white; }
  button.pedal { min-height: 52px; margin-top: 12px; background: #34444b; color: #eef5f3; font-size: 1.1rem; }
  button.pedal.on { background: #20c68a; color: #082c25; }
  button.pedal.fuzz.on { background: #f0b968; color: #262018; }
  .pedal-row { display: grid; grid-template-columns: 1fr 52px; gap: 8px; align-items: end; }
  .pedal-row button.pedal { width: 100%; }
  button.gear { min-height: 52px; margin-top: 12px; background: #34444b; color: #eef5f3; font-size: 1.4rem; }
  .slot { margin: 10px 0; color: #b6c7c8; font-size: .9rem; }
  dialog { width: min(360px, calc(100% - 48px)); border: 1px solid #637782; border-radius: 16px; padding: 24px; background: #1d282e; color: #eef5f3; }
  dialog::backdrop { background: #000a; }
  dialog h2 { margin: 0 0 16px; }
  dialog .setting { margin: 15px 0; }
  dialog .setting label { display: flex; justify-content: space-between; }
  dialog button { min-height: 44px; font-size: 1rem; }
  button.swap { min-height: 42px; margin-top: 12px; background: transparent; border: 1px solid #637782; color: #eef5f3; font-size: 1rem; }
  button.swap[hidden] { display: none; }
  .path { margin: 18px 0 12px; font-weight: 600; color: #eef5f3; }
  button:focus-visible, input:focus-visible { outline: 3px solid #f5d562; outline-offset: 3px; }
  .row { display: flex; justify-content: space-between; align-items: center; margin: 32px 0 12px; font-weight: 600; }
  input[type=range] { width: 100%; accent-color: #20c68a; cursor: pointer; }
  .hint { margin-top: 25px; font-size: .9rem; min-height: 1.3em; }
</style>
</head>
<body>
<main>
  <h1>Guitar Pedal Board</h1>
  <p>Build the signal path from input to output</p>
  <button id="toggle" type="button" aria-pressed="true">Signal ON</button>
  <p id="path" class="path">INPUT → OVERDRIVE → OUTPUT</p>
  <p id="slots" class="slot">Slot 1: Overdrive · Slot 2: Empty</p>
  <div class="pedal-row"><button id="overdrive" class="pedal" type="button" aria-pressed="true">Overdrive on board</button><button id="overdrive-gear" class="gear" type="button" aria-label="Overdrive settings">⚙</button></div>
  <div class="pedal-row"><button id="fuzz" class="pedal fuzz" type="button" aria-pressed="false">Add fuzz</button><button id="fuzz-gear" class="gear" type="button" aria-label="Fuzz settings">⚙</button></div>
  <button id="swap" class="swap" type="button" hidden>Reverse pedal order</button>
  <div class="row"><label for="amount">Effect amount</label><output id="value">100%</output></div>
  <input id="amount" type="range" min="0" max="100" value="100" aria-label="Effect amount">
  <p id="status" class="hint" role="status">Connecting…</p>
</main>
<dialog id="config"><h2 id="config-title"></h2><div id="config-fields"></div><button id="config-close" type="button">Close</button></dialog>
<script>
const toggle = document.getElementById('toggle');
const overdrive = document.getElementById('overdrive');
const fuzz = document.getElementById('fuzz');
const swap = document.getElementById('swap');
const path = document.getElementById('path');
const slotsText = document.getElementById('slots');
const config = document.getElementById('config');
const configTitle = document.getElementById('config-title');
const configFields = document.getElementById('config-fields');
const amount = document.getElementById('amount');
const value = document.getElementById('value');
const status = document.getElementById('status');
let enabled = true;
let slots = ['overdrive', null];
let settings = {};
let dragging = false;
let timer;
function render(state) {
  enabled = state.enabled;
  slots = state.slots || [...(state.pedals || [state.effect_type || 'overdrive']), null].slice(0, 2);
  settings = state.settings || {};
  const pedals = slots.filter(Boolean);
  toggle.textContent = enabled ? 'Signal ON' : 'Bypassed';
  toggle.classList.toggle('clean', !enabled);
  toggle.setAttribute('aria-pressed', String(enabled));
  path.textContent = ['INPUT', ...pedals.map(pedal => pedal.toUpperCase()), 'OUTPUT'].join(' → ');
  slotsText.textContent = slots.map((pedal, index) => `Slot ${index + 1}: ${pedal || 'Empty'}`).join(' · ');
  for (const [button, name] of [[overdrive, 'overdrive'], [fuzz, 'fuzz']]) {
    const active = pedals.includes(name);
    button.textContent = active ? `${name} on board` : `Add ${name}`;
    button.classList.toggle('on', active);
    button.setAttribute('aria-pressed', String(active));
  }
  swap.hidden = pedals.length === 0;
  if (!dragging) { amount.value = Math.round(state.amount * 100); value.textContent = amount.value + '%'; }
  status.textContent = enabled ? `${pedals.length} pedal${pedals.length === 1 ? '' : 's'} in signal path` : 'Signal is bypassed';
}
async function request(path, data) {
  const options = data === undefined ? {} : {method: 'POST', headers: {'Content-Type': 'application/json'}, body: JSON.stringify(data)};
  const response = await fetch(path, options);
  const payload = await response.json();
  if (!response.ok) throw new Error(payload.error || 'Connection failed');
  render(payload);
}
async function refresh() {
  try { await request('/api/state'); } catch (error) { status.textContent = error.message; }
}
toggle.addEventListener('click', async () => {
  try { await request('/api/mode', {enabled: !enabled}); } catch (error) { status.textContent = error.message; }
});
for (const [button, name] of [[overdrive, 'overdrive'], [fuzz, 'fuzz']]) {
  button.addEventListener('click', async () => {
    const next = [...slots];
    const index = next.indexOf(name);
    if (index >= 0) next[index] = null;
    else if (next.indexOf(null) >= 0) next[next.indexOf(null)] = name;
    try { await request('/api/slots', {slots: next}); }
    catch (error) { status.textContent = error.message; }
  });
}
swap.addEventListener('click', async () => {
  try { await request('/api/slots', {slots: [...slots].reverse()}); }
  catch (error) { status.textContent = error.message; }
});
const specs = {
  overdrive: [['drive', 1, 100, 1], ['tone', 100, 8000, 1], ['mix', 0, 1, .01], ['level', 0, 1, .01]],
  fuzz: [['drive', 1, 100, 1], ['tone', 100, 8000, 1], ['level', 0, 1, .01]]
};
for (const name of ['overdrive', 'fuzz']) {
  document.getElementById(name + '-gear').addEventListener('click', () => {
    configTitle.textContent = name[0].toUpperCase() + name.slice(1) + ' settings';
    configFields.replaceChildren();
    for (const [key, min, max, step] of specs[name]) {
      const row = document.createElement('div'); row.className = 'setting';
      const label = document.createElement('label'); label.textContent = key[0].toUpperCase() + key.slice(1);
      const output = document.createElement('output'); output.textContent = String(settings[name]?.[key] ?? min);
      const slider = document.createElement('input'); slider.type = 'range';
      Object.assign(slider, {min, max, step, value: settings[name]?.[key] ?? min});
      slider.setAttribute('aria-label', `${name} ${key}`);
      slider.addEventListener('input', () => { output.textContent = slider.value; });
      slider.addEventListener('change', async () => {
        try { await request('/api/config', {pedal: name, setting: key, value: Number(slider.value)}); }
        catch (error) { status.textContent = error.message; }
      });
      label.append(output); row.append(label, slider); configFields.append(row);
    }
    config.showModal();
  });
}
document.getElementById('config-close').addEventListener('click', () => config.close());
amount.addEventListener('input', () => {
  dragging = true;
  value.textContent = amount.value + '%';
  clearTimeout(timer);
  timer = setTimeout(async () => {
    try { await request('/api/amount', {amount: Number(amount.value) / 100}); }
    catch (error) { status.textContent = error.message; }
    dragging = false;
  }, 60);
});
amount.addEventListener('change', () => { dragging = false; });
refresh();
setInterval(refresh, 2000);
</script>
</body>
</html>"""


class Handler(BaseHTTPRequestHandler):
    def _reply(self, status: int, body: bytes, content_type: str) -> None:
        self.send_response(status)
        self.send_header("Content-Type", content_type)
        self.send_header("Cache-Control", "no-store")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def _state(self) -> dict:
        return json.loads(send_mode_command("state"))

    def _json(self, status: int, payload: dict) -> None:
        self._reply(status, json.dumps(payload).encode(), "application/json; charset=utf-8")

    def do_GET(self) -> None:
        if self.path == "/":
            self._reply(200, PAGE.encode(), "text/html; charset=utf-8")
        elif self.path == "/api/state":
            try:
                self._json(200, self._state())
            except (OSError, ValueError) as error:
                self._json(503, {"error": str(error)})
        else:
            self._json(404, {"error": "Not found"})

    def do_POST(self) -> None:
        if self.path not in ("/api/mode", "/api/amount", "/api/type", "/api/board", "/api/slots", "/api/config"):
            self._json(404, {"error": "Not found"})
            return
        try:
            length = int(self.headers.get("Content-Length", "0"))
            if not 0 < length <= 256:
                raise ValueError("Invalid request size")
            payload = json.loads(self.rfile.read(length))
            if self.path == "/api/mode":
                enabled = payload["enabled"]
                if not isinstance(enabled, bool):
                    raise ValueError("enabled must be true or false")
                command = "effect" if enabled else "clean"
            elif self.path == "/api/amount":
                amount = payload["amount"]
                if isinstance(amount, bool) or not isinstance(amount, (int, float)) or not 0 <= amount <= 1:
                    raise ValueError("amount must be between 0 and 1")
                command = f"amount {amount}"
            elif self.path == "/api/type":
                command = payload["effect_type"]
                if command not in ("overdrive", "fuzz"):
                    raise ValueError("effect_type must be overdrive or fuzz")
            elif self.path == "/api/slots":
                slots = payload["slots"]
                if not isinstance(slots, list) or len(slots) != 2 or any(pedal is not None and pedal not in ("overdrive", "fuzz") for pedal in slots) or len([pedal for pedal in slots if pedal is not None]) != len(set(pedal for pedal in slots if pedal is not None)):
                    raise ValueError("slots must contain two unique pedal names or null")
                command = "slots " + ",".join(pedal or "-" for pedal in slots)
            elif self.path == "/api/config":
                pedal, setting, value = payload["pedal"], payload["setting"], payload["value"]
                if pedal not in ("overdrive", "fuzz") or setting not in ("drive", "tone", "mix", "level") or isinstance(value, bool) or not isinstance(value, (int, float)):
                    raise ValueError("invalid pedal setting")
                command = f"config {pedal} {setting} {value}"
            else:
                pedals = payload["pedals"]
                if not isinstance(pedals, list) or len(pedals) > 2 or len(set(pedals)) != len(pedals) or any(pedal not in ("overdrive", "fuzz") for pedal in pedals):
                    raise ValueError("pedals must be a list of unique overdrive/fuzz names")
                command = "board " + (",".join(pedals) or "-")
            response = send_mode_command(command)
            if response.startswith("error:"):
                raise ValueError(response)
            self._json(200, self._state())
        except (KeyError, TypeError, ValueError, json.JSONDecodeError) as error:
            self._json(400, {"error": str(error)})
        except OSError as error:
            self._json(503, {"error": str(error)})

    def log_message(self, _format: str, *_args: object) -> None:
        pass


def _ensure_effect(output_device: str) -> subprocess.Popen | None:
    try:
        send_mode_command("state")
        return None
    except OSError:
        process = subprocess.Popen([
            sys.executable, "-m", "ml_guitar_pedal.cli", "effect", "--output", output_device,
        ])
        for _ in range(50):
            if process.poll() is not None:
                raise RuntimeError("The guitar effect could not start; check the iRig connection")
            try:
                send_mode_command("state")
                return process
            except OSError:
                time.sleep(0.1)
        process.terminate()
        process.wait()
        raise RuntimeError("The guitar effect did not become ready")


def main(argv: list[str] | None = None) -> None:
    parser = argparse.ArgumentParser(description="Serve a local browser UI for the live guitar effect.")
    parser.add_argument("--port", type=int, default=8765)
    parser.add_argument("--output", default="default", help="ALSA playback device (default: system audio)")
    args = parser.parse_args(argv)
    if not 1 <= args.port <= 65535:
        parser.error("port must be between 1 and 65535")
    process = _ensure_effect(args.output)
    try:
        with ThreadingHTTPServer(("127.0.0.1", args.port), Handler) as server:
            print(f"Guitar pedal UI: http://127.0.0.1:{args.port} (use an SSH tunnel from your computer)", flush=True)
            server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        if process is not None and process.poll() is None:
            process.terminate()
            process.wait()


if __name__ == "__main__":
    main()
