#!/usr/bin/env bash
#
# Trashie — open the bundled arcade game as a chromeless web-app window.
#
# What this does: resolves game/index.html next to this script and hands it to
# Omarchy's own web-app launcher (default supported browser, --app mode). If a
# Trashie window is already open it is focused instead of spawning a second one.
#
# It writes nothing to disk, makes no network calls, and needs no privileges.

set -euo pipefail

here="$(cd -- "$(dirname -- "$(realpath -- "$0")")/.." && pwd)"
game="$here/game/index.html"

if [ ! -f "$game" ] || [ -L "$game" ]; then
  notify-send "Trashie" "game file not found: $game" 2>/dev/null || true
  exit 1
fi

url="file://$game"

if command -v omarchy-launch-or-focus-webapp >/dev/null 2>&1; then
  exec omarchy-launch-or-focus-webapp "trashie" "$url" --class=trashie --name=trashie
elif command -v omarchy-launch-webapp >/dev/null 2>&1; then
  exec omarchy-launch-webapp "$url" --class=trashie --name=trashie
else
  exec setsid -f xdg-open "$url"
fi
