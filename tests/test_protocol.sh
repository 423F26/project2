#!/usr/bin/env bash
set -euo pipefail
engine=$1
control=$2
web=$3
tmp=$(mktemp -d)
engine_pid=
web_pid=
cleanup() {
  if [[ -n $web_pid ]]; then kill "$web_pid" 2>/dev/null || true; wait "$web_pid" 2>/dev/null || true; fi
  if [[ -n $engine_pid ]]; then kill "$engine_pid" 2>/dev/null || true; wait "$engine_pid" 2>/dev/null || true; fi
  rm -rf "$tmp"
}
trap cleanup EXIT
export PEDAL_CONTROL_SOCKET="$tmp/pedal.sock"
"$engine" --no-audio --socket "$PEDAL_CONTROL_SOCKET" >"$tmp/engine.log" 2>&1 &
engine_pid=$!
for i in {1..100}; do [[ -S $PEDAL_CONTROL_SOCKET ]] && break; sleep .02; done
[[ -S $PEDAL_CONTROL_SOCKET ]]
"$control" state | jq -e '.pedals == ["overdrive"] and .enabled == true'
"$control" board fuzz,delay | jq -e '.pedals == ["fuzz","delay"]'
"$control" config delay time 450 | jq -e '.settings.delay.time == 450'
"$control" board - | jq -e '.pedals == []'
if "$control" slots fuzz,- >"$tmp/invalid" 2>&1; then exit 1; fi
"$control" lv2-list | jq -e 'has("plugins")'
"$control" state | jq -e '.tuner.enabled == true and .tuner.note == null and .midi.queued == 0'
"$control" tuner off | jq -e '.tuner.enabled == false'
"$control" tuner on | jq -e '.tuner.enabled == true'
"$control" midi-events | jq -e '.events == [] and .dropped == 0'
port=$((20000 + RANDOM % 30000))
"$web" --port "$port" --html "$(dirname "$0")/../web/index.html" >"$tmp/web.log" 2>&1 &
web_pid=$!
for i in {1..100}; do curl -fsS "http://127.0.0.1:$port/api/state" >"$tmp/state" 2>/dev/null && break; sleep .02; done
jq -e '.pedals == []' "$tmp/state"
curl -fsS "http://127.0.0.1:$port/" | grep -q 'Import effect'
curl -fsS -H 'Content-Type: application/json' -d '{"pedals":["chorus","tremolo"]}' "http://127.0.0.1:$port/api/board" | jq -e '.pedals == ["chorus","tremolo"]'
curl -fsS -H 'Content-Type: application/json' -d '{"enabled":false}' "http://127.0.0.1:$port/api/mode" | jq -e '.enabled == false'
curl -fsS "http://127.0.0.1:$port/api/lv2" | jq -e 'has("plugins")'
curl -fsS "http://127.0.0.1:$port/api/midi" | jq -e '.events == []'
curl -fsS -H 'Content-Type: application/json' -d '{"enabled":false}' "http://127.0.0.1:$port/api/tuner" | jq -e '.tuner.enabled == false'
curl -fsS -H 'Content-Type: application/json' -d '{"enabled":true}' "http://127.0.0.1:$port/api/tuner" | jq -e '.tuner.enabled == true'

# Exercise the browser's LV2 import path when this machine has a compatible plugin.
plugin_uri=$(curl -fsS "http://127.0.0.1:$port/api/lv2" | jq -r '.plugins[0].uri // empty')
if [[ -n $plugin_uri ]]; then
  jq -n --arg uri "$plugin_uri" '{uri:$uri}' >"$tmp/import.json"
  curl -fsS -H 'Content-Type: application/json' --data-binary "@$tmp/import.json" "http://127.0.0.1:$port/api/import" | jq -e '.available | has("lv2-1")'
  curl -fsS -H 'Content-Type: application/json' -d '{"pedals":["lv2-1"]}' "http://127.0.0.1:$port/api/board" | jq -e '.pedals == ["lv2-1"]'
fi
