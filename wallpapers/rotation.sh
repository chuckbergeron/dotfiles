#!/usr/bin/env bash
# Manage the launchd agent that rotates the wallpaper on a timer.
#
# macOS has no user cron worth using for GUI work. launchd is the supported
# mechanism, and unlike cron it catches up on a fire it missed while the
# machine was asleep, which matters for a 6 hour interval on a laptop.
#
# Usage: ./rotation.sh install [hours]   (default 6)
#        ./rotation.sh uninstall
#        ./rotation.sh status
#        ./rotation.sh run                (fire once, now)
set -euo pipefail

LABEL="com.chuckbergeron.wallpaper-rotate"
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
TARGET="$HOME/Pictures/Wallpapers/set-wallpaper.sh"
LOG="$HOME/Library/Logs/wallpaper-rotate.log"
DOMAIN="gui/$(id -u)"

install_agent() {
  local hours="${1:-6}"
  local seconds=$(( hours * 3600 ))
  [ -x "$TARGET" ] || { echo "Not found or not executable: $TARGET"; echo "Run fetch.sh first."; exit 1; }

  mkdir -p "$(dirname "$PLIST")" "$(dirname "$LOG")"
  cat > "$PLIST" <<PLISTEOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$LABEL</string>
    <key>ProgramArguments</key>
    <array>
        <string>$TARGET</string>
    </array>
    <key>StartInterval</key>
    <integer>$seconds</integer>
    <key>RunAtLoad</key>
    <false/>
    <key>StandardOutPath</key>
    <string>$LOG</string>
    <key>StandardErrorPath</key>
    <string>$LOG</string>
    <key>ProcessType</key>
    <string>Background</string>
</dict>
</plist>
PLISTEOF

  # bootout first so re-installing picks up a changed interval.
  launchctl bootout "$DOMAIN/$LABEL" 2>/dev/null || true
  launchctl bootstrap "$DOMAIN" "$PLIST"
  echo "Installed: rotating every $hours hours."
  echo "Log: $LOG"
}

uninstall_agent() {
  launchctl bootout "$DOMAIN/$LABEL" 2>/dev/null || true
  rm -f "$PLIST"
  echo "Uninstalled."
}

status_agent() {
  if [ ! -f "$PLIST" ]; then
    echo "Not installed."
    return 0
  fi
  local secs
  secs=$(/usr/libexec/PlistBuddy -c "Print :StartInterval" "$PLIST" 2>/dev/null || echo "?")
  echo "Plist:    $PLIST"
  echo "Interval: every $(( secs / 3600 )) hours"
  if launchctl print "$DOMAIN/$LABEL" >/dev/null 2>&1; then
    echo "Loaded:   yes"
  else
    echo "Loaded:   NO (run './rotation.sh install' to load it)"
  fi
  [ -f "$HOME/Pictures/Wallpapers/.last" ] && \
    echo "Current:  $(cat "$HOME/Pictures/Wallpapers/.last")"
  if [ -f "$LOG" ]; then
    echo "Last log lines:"
    tail -3 "$LOG" | sed 's/^/  /'
  fi
}

case "${1:-status}" in
  install)   install_agent "${2:-6}" ;;
  uninstall) uninstall_agent ;;
  status)    status_agent ;;
  run)       launchctl kickstart -p "$DOMAIN/$LABEL" ;;
  *)         echo "Usage: $0 {install [hours]|uninstall|status|run}"; exit 1 ;;
esac
