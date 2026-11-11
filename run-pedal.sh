#!/usr/bin/env bash
# Shared desktop and login launcher for the current source checkout.
set -Eeuo pipefail
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
cd "$root"
cache="${XDG_CACHE_HOME:-$HOME/.cache}/ml-guitar-pedal"
mkdir -p "$cache"
export PEDAL_CONTROL_SOCKET="$cache/control.sock"
engine="$root/build/release/pedal-engine"
audio_device="${PEDAL_AUDIO_DEVICE:-plughw:CARD=sndrpihifiberry,DEV=0}"
ctl="$root/build/release/pedalctl"
ui="$root/build/lvgl/pedal-lvgl"
preview=false
fullscreen=true
check=false
for argument in "$@"; do
    case "$argument" in
        --preview) preview=true ;;
        --windowed) fullscreen=false ;;
        --check) check=true ;;
        *) echo "Usage: $0 [--preview] [--windowed] [--check]" >&2; exit 2 ;;
    esac
done
fail() {
    echo "$*" >&2
    if ! $check; then
        if command -v zenity >/dev/null; then zenity --error --title='Guitar Pedal' --text="$*" || true
        elif command -v notify-send >/dev/null; then notify-send -u critical 'Guitar Pedal' "$*" || true; fi
    fi
    exit 1
}
if ! $check; then
    [[ -n "${DISPLAY:-}${WAYLAND_DISPLAY:-}${SDL_VIDEODRIVER:-}" ]] || fail 'Open Guitar Pedal from the Pi desktop.'
fi
exec 9>"$cache/launcher.lock"
flock -n 9 || exit 0
"$root/scripts/build-pedal.sh" >>"$cache/launcher.log" 2>&1 || fail "Pedal build failed. Details: $cache/launcher.log"
for binary in "$engine" "$ctl" "$ui"; do
    [[ -x "$binary" ]] || fail "Pedal build missing: $binary"
done
if ! $preview; then
    ready=false
    for attempt in {1..60}; do
        if [[ -e /proc/asound/sndrpihifiberry || -n "${PEDAL_AUDIO_DEVICE:-}" ]]; then ready=true; break; fi
        sleep .5
    done
    $ready || fail 'The ADAC audio interface is unavailable. Check the HiFiBerry overlay and board connection.'
fi
if $check; then echo 'Audio interface and current native pedal builds are ready.'; exit 0; fi
exec >>"$cache/launcher.log" 2>&1
export LV2_PATH="$root/build/release/lv2:${LV2_PATH:-$HOME/.lv2:/usr/local/lib/lv2:/usr/lib/lv2}"
owned_engine=
session_ready=false
cleanup() {
    if ! $preview && $session_ready; then python3 "$root/scripts/pedal-session.py" save || true; fi
    if [[ -n "$owned_engine" ]]; then
        kill "$owned_engine" 2>/dev/null || true
        wait "$owned_engine" 2>/dev/null || true
    fi
}
trap cleanup EXIT
trap 'exit 130' INT TERM HUP
arguments=()
if ! $preview; then
    if ! "$ctl" state >/dev/null 2>&1; then
        "$engine" --input "$audio_device" --output "$audio_device" --rate 48000 --block 128 --meter 9>&- &
        owned_engine=$!
        ready=false
        for attempt in {1..100}; do
            if "$ctl" state >/dev/null 2>&1; then ready=true; break; fi
            kill -0 "$owned_engine" 2>/dev/null || break
            sleep .05
        done
        $ready || fail "Audio could not start. Details: $cache/launcher.log"
        python3 "$root/scripts/pedal-session.py" restore
    fi
    session_ready=true
    arguments+=(--live)
fi
if $fullscreen; then arguments+=(--fullscreen); fi
"$ui" "${arguments[@]}" 9>&- || fail "Native UI could not open. Details: $cache/launcher.log"
