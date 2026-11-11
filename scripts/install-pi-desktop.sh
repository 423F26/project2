#!/usr/bin/env bash
# Install the same launcher for the desktop, application menu and optional login.
set -euo pipefail
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
autostart=false
case "${1:-}" in
    '') ;;
    --autostart) autostart=true ;;
    *) echo "Usage: $0 [--autostart]" >&2; exit 2 ;;
esac
[[ $# -le 1 ]] || { echo "Usage: $0 [--autostart]" >&2; exit 2; }
desktop_dir=$(xdg-user-dir DESKTOP 2>/dev/null || true)
if [[ -z "$desktop_dir" || "$desktop_dir" == "$HOME" ]]; then desktop_dir="$HOME/Desktop"; fi
applications_dir="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
autostart_dir="${XDG_CONFIG_HOME:-$HOME/.config}/autostart"
python3 - "$root" "$desktop_dir" "$applications_dir" "$autostart_dir" "$autostart" <<'PY'
from pathlib import Path
import sys

root, desktop, applications, autostart = map(Path, sys.argv[1:5])
text = (root / 'Riffline.desktop').read_text()
# Desktop Entry Exec is parsed without a shell; quote reserved characters.
executable = str(root / 'run-pedal.sh')
escaped = ''.join('\\' + c if c in '\\"`$' else c for c in executable)
escaped = escaped.replace('\\', '\\\\').replace('%', '%%')
text = '\n'.join(
    'Exec="' + escaped + '"' if line.startswith('Exec=') else
    'Icon=' + str(root / 'assets/riffline.svg').replace('\\', '\\\\') if line.startswith('Icon=') else
    'Path=' + str(root).replace('\\', '\\\\') if line.startswith('Path=') else line
    for line in text.splitlines()
) + '\n'
destinations = [desktop / 'Riffline.desktop', applications / 'guitar-pedal.desktop']
if sys.argv[5] == 'true':
    destinations.append(autostart / 'guitar-pedal.desktop')
for destination in destinations:
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_text(text)
    destination.chmod(0o755)
    print('Installed:', destination)
# PCManFM displays the desktop filename even when the entry has a new Name.
# Remove only the older shortcut generated for this exact launcher.
legacy = desktop / 'Guitar Pedal.desktop'
if legacy.is_file() and 'Exec="' + escaped + '"' in legacy.read_text().splitlines():
    legacy.unlink()
PY
if command -v gio >/dev/null; then
    gio set "$desktop_dir/Riffline.desktop" metadata::trusted true 2>/dev/null || true
fi
