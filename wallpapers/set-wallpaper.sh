#!/bin/bash
# Set the desktop AND lock screen wallpaper.
# Usage: ./set-wallpaper.sh 7      (number from the list)
#        ./set-wallpaper.sh        (random, never repeats the current one)
set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAST="$DIR/.last"

if [ -n "${1:-}" ]; then
  F=$(ls "$DIR" | grep -E "^0?$1-" | head -1)
else
  prev=""
  [ -f "$LAST" ] && prev=$(cat "$LAST")
  F=$(ls "$DIR" | grep -E '^[0-9]{2}-' | grep -vxF "$prev" | sort -R | head -1)
fi
[ -z "$F" ] && { echo "No wallpaper matching '${1:-}'"; exit 1; }

"$DIR/set-wallpaper.py" "$DIR/$F"
printf '%s' "$F" > "$LAST"
