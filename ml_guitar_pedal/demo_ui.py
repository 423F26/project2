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
<title>Guitar Pedal</title>
<style>
  :root { color-scheme: dark; font-family: system-ui, sans-serif; }
  body { margin: 0; min-height: 100vh; display: grid; place-items: center; background: #11171c; color: #eef5f3; }
  main { box-sizing: border-box; width: min(440px, calc(100% - 32px)); padding: 28px; border: 1px solid #34444b; border-radius: 20px; background: #1d282e; box-shadow: 0 20px 60px #0005; }
  h1 { margin: 0 0 6px; font-size: 1.65rem; }
  p { color: #b6c7c8; margin: 0 0 26px; }
  button { width: 100%; min-height: 88px; border: 0; border-radius: 15px; background: #20c68a; color: #082c25; font: 700 1.55rem system-ui; cursor: pointer; }
  button.clean { background: #637782; color: white; }
  button:focus-visible, input:focus-visible { outline: 3px solid #f5d562; outline-offset: 3px; }
  .row { display: flex; justify-content: space-between; align-items: center; margin: 32px 0 12px; font-weight: 600; }
  input[type=range] { width: 100%; accent-color: #20c68a; cursor: pointer; }
  .hint { margin-top: 25px; font-size: .9rem; min-height: 1.3em; }
</style>
</head>
<body>
<main>
  <h1>Guitar Pedal</h1>
  <p>Live control of the Raspberry Pi effect</p>
  <button id="toggle" type="button" aria-pressed="true">Effect ON</button>
  <div class="row"><label for="amount">Effect amount</label><output id="value">100%</output></div>
  <input id="amount" type="range" min="0" max="100" value="100" aria-label="Effect amount">
  <p id="status" class="hint" role="status">Connecting…</p>
</main>
<script>
const toggle = document.getElementById('toggle');
const amount = document.getElementById('amount');
const value = document.getElementById('value');
const status = document.getElementById('status');
let enabled = true;
let dragging = false;
let timer;
function render(state) {
  enabled = state.enabled;
  toggle.textContent = enabled ? 'Effect ON' : 'Clean';
  toggle.classList.toggle('clean', !enabled);
  toggle.setAttribute('aria-pressed', String(enabled));
  if (!dragging) { amount.value = Math.round(state.amount * 100); value.textContent = amount.value + '%'; }
  status.textContent = enabled ? 'Overdrive is active' : 'Clean guitar is active';
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
        if self.path not in ("/api/mode", "/api/amount"):
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
            else:
                amount = payload["amount"]
                if isinstance(amount, bool) or not isinstance(amount, (int, float)) or not 0 <= amount <= 1:
                    raise ValueError("amount must be between 0 and 1")
                command = f"amount {amount}"
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


def _ensure_effect() -> subprocess.Popen | None:
    try:
        send_mode_command("state")
        return None
    except OSError:
        process = subprocess.Popen([sys.executable, "-m", "ml_guitar_pedal.cli", "effect"])
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
    args = parser.parse_args(argv)
    if not 1 <= args.port <= 65535:
        parser.error("port must be between 1 and 65535")
    process = _ensure_effect()
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
