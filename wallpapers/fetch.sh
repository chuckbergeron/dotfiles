#!/usr/bin/env bash
# Re-download the wallpaper set described by manifest.json.
#
# The image files are deliberately not tracked in this repo (see README.md);
# this fetches them from source onto a new machine. Safe to re-run: files that
# are already present with the right checksum are left alone.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${1:-$HOME/Pictures/Wallpapers}"
MANIFEST="$DIR/manifest.json"

command -v jq >/dev/null || { echo "This needs jq: brew install jq"; exit 1; }

mkdir -p "$DEST"
cp "$DIR/set-wallpaper.py" "$DIR/set-wallpaper.sh" "$DEST/"
chmod +x "$DEST/set-wallpaper.py" "$DEST/set-wallpaper.sh"

total=$(jq -r '.count' "$MANIFEST")
have=0; got=0; failed=0

while IFS=$'\t' read -r file url want; do
  path="$DEST/$file"
  if [ -f "$path" ] && [ "$(shasum -a 256 "$path" | cut -d' ' -f1)" = "$want" ]; then
    have=$((have + 1)); continue
  fi
  printf 'fetching %s ... ' "$file"
  if ! curl -sSfL --retry 2 -o "$path.part" "$url"; then
    echo "FAILED (download)"; rm -f "$path.part"; failed=$((failed + 1)); continue
  fi
  actual=$(shasum -a 256 "$path.part" | cut -d' ' -f1)
  if [ "$actual" != "$want" ]; then
    # The source is a third-party host; a changed file is a real possibility.
    echo "FAILED (checksum mismatch - source file may have changed)"
    rm -f "$path.part"; failed=$((failed + 1)); continue
  fi
  mv "$path.part" "$path"
  echo "ok"; got=$((got + 1))
done < <(jq -r '.wallpapers[] | [.file, .source, .sha256] | @tsv' "$MANIFEST")

echo
echo "$total in manifest: $have already present, $got downloaded, $failed failed."
[ "$failed" -gt 0 ] && echo "Failed entries are listed above; their source URLs are in manifest.json."
echo "Set one with: $DEST/set-wallpaper.sh <number>"
exit 0
