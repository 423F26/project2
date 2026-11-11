#!/usr/bin/env bash
set -euo pipefail

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
build_dir="$root/build/release"
cmake -S "$root" -B "$build_dir" -DCMAKE_BUILD_TYPE=Release
cmake --build "$build_dir" --parallel "${PEDAL_BUILD_JOBS:-2}" --target pedal-engine pedal-web

runtime_dir=$(mktemp -d "${TMPDIR:-/tmp}/pedal-demo.XXXXXX")
engine_pid=
web_pid=
cleanup() {
  [[ -z "$web_pid" ]] || kill "$web_pid" 2>/dev/null || true
  [[ -z "$engine_pid" ]] || kill "$engine_pid" 2>/dev/null || true
  [[ -z "$web_pid" ]] || wait "$web_pid" 2>/dev/null || true
  [[ -z "$engine_pid" ]] || wait "$engine_pid" 2>/dev/null || true
  rm -rf -- "$runtime_dir"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

export PEDAL_CONTROL_SOCKET="$runtime_dir/control.sock"
"$build_dir/pedal-engine" --socket "$PEDAL_CONTROL_SOCKET" "$@" &
engine_pid=$!
for ((attempt = 0; attempt < 50; attempt++)); do
  [[ -S "$PEDAL_CONTROL_SOCKET" ]] && break
  if ! kill -0 "$engine_pid" 2>/dev/null; then
    wait "$engine_pid"
    exit 1
  fi
  sleep 0.1
done
if [[ ! -S "$PEDAL_CONTROL_SOCKET" ]]; then
  echo "Pedal engine did not start its control socket" >&2
  exit 1
fi
"$build_dir/pedal-web" --html "$root/web/index.html" --port "${PEDAL_WEB_PORT:-8765}" &
web_pid=$!
wait -n "$engine_pid" "$web_pid"
