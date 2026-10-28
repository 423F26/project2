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
if "$engine" --rate 7999 --no-audio >"$tmp/invalid-rate" 2>&1; then exit 1; fi
if "$engine" --block 0 --no-audio >"$tmp/invalid-block" 2>&1; then exit 1; fi
export PEDAL_CONTROL_SOCKET="$tmp/pedal.sock"
"$engine" --no-audio --socket "$PEDAL_CONTROL_SOCKET" >"$tmp/engine.log" 2>&1 &
engine_pid=$!
for i in {1..100}; do [[ -S $PEDAL_CONTROL_SOCKET ]] && break; sleep .02; done
[[ -S $PEDAL_CONTROL_SOCKET ]]
"$control" state | jq -e '.pedals == ["overdrive"] and .enabled == true'
"$control" board fuzz,delay | jq -e '.pedals == ["fuzz","delay"]'
"$control" config delay time 450 | jq -e '.settings.delay.time == 450'
if "$control" config delay time 2000 >"$tmp/invalid" 2>&1; then exit 1; fi
if "$control" board fuzz,fuzz >"$tmp/invalid" 2>&1; then exit 1; fi
"$control" state | jq -e '.pedals == ["fuzz","delay"] and .settings.delay.time == 450'
"$control" board - | jq -e '.pedals == []'
if "$control" slots fuzz,- >"$tmp/invalid" 2>&1; then exit 1; fi
"$control" lv2-list | jq -e 'any(.plugins[]; .uri == "https://example.org/c-pedal/test-gain")'
if "$control" lv2-load https://example.org/c-pedal/missing >"$tmp/invalid" 2>&1; then exit 1; fi
"$control" state | jq -e '.tuner.enabled == true and .tuner.note == null and .midi.queued == 0'
"$control" tuner off | jq -e '.tuner.enabled == false'
"$control" tuner on | jq -e '.tuner.enabled == true'
"$control" midi-events | jq -e '.events == [] and .dropped == 0'
"$control" amount 0.7 | jq -e '(.amount - 0.7 | abs) < 0.000001'
if "$control" amount 1.1 >"$tmp/invalid" 2>&1; then exit 1; fi
"$control" state | jq -e '(.amount - 0.7 | abs) < 0.000001'
"$control" clean | grep -qx clean
"$control" state | jq -e '.enabled == false'
"$control" effect | grep -qx effect
port=$((20000 + RANDOM % 30000))
"$web" --port "$port" --html "$(dirname "$0")/../web/index.html" >"$tmp/web.log" 2>&1 &
web_pid=$!
for i in {1..100}; do curl -fsS "http://127.0.0.1:$port/api/state" >"$tmp/state" 2>/dev/null && break; sleep .02; done
jq -e '.pedals == []' "$tmp/state"
curl -fsS "http://127.0.0.1:$port/" >"$tmp/page"
grep -q 'Import effect' "$tmp/page"
curl -fsS -H 'Content-Type: application/json' -d '{"pedals":["chorus","tremolo"]}' "http://127.0.0.1:$port/api/board" | jq -e '.pedals == ["chorus","tremolo"]'
curl -fsS -H 'Content-Type: application/json' -d '{"enabled":false}' "http://127.0.0.1:$port/api/mode" | jq -e '.enabled == false'
curl -fsS "http://127.0.0.1:$port/api/lv2" | jq -e 'any(.plugins[]; .uri == "https://example.org/c-pedal/test-gain")'
curl -fsS "http://127.0.0.1:$port/api/midi" | jq -e '.events == []'
curl -fsS -H 'Content-Type: application/json' -d '{"enabled":false}' "http://127.0.0.1:$port/api/tuner" | jq -e '.tuner.enabled == false'
curl -fsS -H 'Content-Type: application/json' -d '{"enabled":true}' "http://127.0.0.1:$port/api/tuner" | jq -e '.tuner.enabled == true'
curl -fsS -H 'Content-Type: application/json' -d '{"amount":0.4}' "http://127.0.0.1:$port/api/amount" | jq -e '(.amount - 0.4 | abs) < 0.000001'
curl -fsS -H 'Content-Type: application/json' -d '{"pedal":"chorus","setting":"mix","value":0.2}' "http://127.0.0.1:$port/api/config" | jq -e '(.settings.chorus.mix - 0.2 | abs) < 0.000001'
for payload in '{"pedals":["chorus","chorus"]}' '{"pedals":["missing"]}'; do
  code=$(curl -sS -o "$tmp/rejected" -w '%{http_code}' -H 'Content-Type: application/json' -d "$payload" "http://127.0.0.1:$port/api/board")
  [[ $code == 400 ]]
done
code=$(curl -sS -o "$tmp/rejected" -w '%{http_code}' -H 'Content-Type: application/json' -d '{"amount":2}' "http://127.0.0.1:$port/api/amount")
[[ $code == 400 ]]
code=$(curl -sS -o "$tmp/rejected" -w '%{http_code}' -H 'Content-Type: application/json' -d '{"pedal":"chorus","setting":"mix","value":2}' "http://127.0.0.1:$port/api/config")
[[ $code == 400 ]]
curl -fsS "http://127.0.0.1:$port/api/state" | jq -e '.pedals == ["chorus","tremolo"] and (.amount - 0.4 | abs) < 0.000001 and (.settings.chorus.mix - 0.2 | abs) < 0.000001'

curl -fsS -H 'Content-Type: application/json' -d '{"uri":"https://example.org/c-pedal/test-gain"}' "http://127.0.0.1:$port/api/import" | jq -e '.available["lv2-1"].settings.gain == 0.5'
curl -fsS -H 'Content-Type: application/json' -d '{"pedals":["lv2-1"]}' "http://127.0.0.1:$port/api/board" | jq -e '.pedals == ["lv2-1"]'
curl -fsS -H 'Content-Type: application/json' -d '{"pedal":"lv2-1","setting":"gain","value":0.25}' "http://127.0.0.1:$port/api/config" | jq -e '(.settings["lv2-1"].gain - 0.25 | abs) < 0.000001'
