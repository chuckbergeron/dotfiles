# Restore per-tab working directories across a Ghostty restart.
#
# Ghostty's macOS state restoration (`window-save-state = always` in
# ghostty/config) reopens windows, tabs and splits, but every restored shell
# starts in the default working directory rather than where the tab was.
# Upstream gap, tracked in ghostty-org/ghostty#7941.
#
# So: record each tab's cwd as it changes, and hand the saved directories back
# to the tabs Ghostty reopens at launch.
#
# Restored tabs get the saved *set* of directories, not a guaranteed
# tab-position-to-directory mapping. Ghostty gives a restored surface no
# identity that survives a restart, so there is nothing to key a mapping on.
#
# A record is dropped when its tab goes away and Ghostty is still running, and
# kept when Ghostty itself is going down, which is the case worth restoring.
# `ghostty-tabs` inspects and clears the saved set by hand.

[[ -o interactive ]] || return
[[ $TERM_PROGRAM == ghostty ]] || return

autoload -Uz add-zsh-hook

# Seconds after Ghostty launch during which a fresh shell counts as a restored
# tab. Ghostty opens every restored tab at once, so this only has to cover
# launch, not a tab opened by hand later on.
typeset -g GHOSTTY_TAB_CWD_WINDOW=${GHOSTTY_TAB_CWD_WINDOW:-25}

# Cap on saved directories, so a long-lived pool cannot grow without bound.
typeset -g GHOSTTY_TAB_CWD_MAX=${GHOSTTY_TAB_CWD_MAX:-40}

typeset -g _gtc_state="${XDG_STATE_HOME:-$HOME/.local/state}/ghostty-tab-cwd"
typeset -g _gtc_live="$_gtc_state/live"
typeset -g _gtc_queue="$_gtc_state/queue"

# Walk up the process tree to the Ghostty app. pgrep is no use here: there can
# be more than one Ghostty process, and only our own ancestor tells us when
# *this* window's instance started.
_gtc_app_pid() {
  emulate -L zsh
  local pid=$$ ppid comm
  local -i hop
  for (( hop = 0; hop < 8; hop++ )); do
    IFS=' ' read -r ppid comm <<< "$(ps -o ppid=,comm= -p $pid 2>/dev/null)"
    [[ -n $ppid ]] || return 1
    [[ ${comm:t} == ghostty ]] && { print -r -- $pid; return 0 }
    (( ppid > 1 )) || return 1
    pid=$ppid
  done
  return 1
}

# The first shell of a Ghostty launch moves the previous session's records into
# a claim queue. Every other shell waits for that snapshot to show up.
_gtc_open_queue() {
  emulate -L zsh
  setopt local_options null_glob
  local app_pid=$1
  local marker="$_gtc_state/launch-pid" lock="$_gtc_state/lock"
  local -i waited

  mkdir -p "$_gtc_state" || return 1
  [[ -f $marker && $(<"$marker") == $app_pid ]] && return 0

  if mkdir "$lock" 2>/dev/null; then
    # Re-check under the lock: another shell may have finished in the meantime.
    if [[ ! -f $marker || $(<"$marker") != $app_pid ]]; then
      rm -rf "$_gtc_queue"
      mv "$_gtc_live" "$_gtc_queue" 2>/dev/null
      mkdir -p "$_gtc_live" "$_gtc_queue"
      # Keep only the most recently touched records.
      local -a extra=("$_gtc_queue"/*(.om[$((GHOSTTY_TAB_CWD_MAX + 1)),-1]))
      (( $#extra )) && rm -f -- $extra
      print -r -- $app_pid > "$marker"
    fi
    rmdir "$lock" 2>/dev/null
    return 0
  fi

  for (( waited = 0; waited < 40; waited++ )); do
    [[ -f $marker && $(<"$marker") == $app_pid ]] && return 0
    sleep 0.05
  done
  # Stale lock left by a shell that died mid-snapshot. Clear it so the next
  # launch is not wedged, and sit this one out.
  rmdir "$lock" 2>/dev/null
  return 1
}

# Claim one saved directory. rename(2) is atomic, so exactly one shell wins
# each entry even though Ghostty starts all the restored tabs at once.
_gtc_claim() {
  emulate -L zsh
  setopt local_options null_glob
  local mine="$_gtc_state/claimed.$$" entry dir
  local -a entries
  while :; do
    entries=("$_gtc_queue"/*(.om))
    (( $#entries )) || return 1
    for entry in $entries; do
      mv "$entry" "$mine" 2>/dev/null || continue   # lost the race, try the next
      dir="$(<"$mine")"
      rm -f "$mine"
      [[ -n $dir && -d $dir ]] && { print -r -- $dir; return 0 }
      break   # ours but unusable (directory is gone), rescan
    done
  done
}

# Elapsed seconds since a process started. macOS ps has no `etimes`, only
# `etime`, formatted [[dd-]hh:]mm:ss. Fields are zero padded, so force base 10
# or zsh reads 08 and 09 as bad octal.
_gtc_uptime() {
  emulate -L zsh
  local raw days rest
  local -a parts
  raw="$(ps -o etime= -p $1 2>/dev/null)"
  raw=${raw//[[:space:]]/}
  [[ $raw == (<->-|)<->:<->(:<->|) ]] || return 1
  if [[ $raw == *-* ]]; then
    days=${raw%%-*}
    rest=${raw#*-}
  else
    days=0
    rest=$raw
  fi
  parts=(${(s.:.)rest})
  case $#parts in
    2) print -r -- $(( 10#$days * 86400 + 10#$parts[1] * 60 + 10#$parts[2] )) ;;
    3) print -r -- $(( 10#$days * 86400 + 10#$parts[1] * 3600 + 10#$parts[2] * 60 + 10#$parts[3] )) ;;
    *) return 1 ;;
  esac
}

# cmd+w and a quit both arrive as SIGHUP, so a closing tab cannot tell which
# one it is. It does not have to: while Ghostty is still running, a record whose
# shell is gone can only belong to a tab that was closed, so any surviving tab
# can drop it later. That keeps live/ down to the genuinely open tabs, which is
# what the launch sweep hands out.
#
# This must never run before the sweep. At launch every pid from the previous
# session is dead, so pruning first would delete exactly what we came to
# restore. It is called from _gtc_record, which runs after _gtc_restore.
#
# `kill -0` is the zsh builtin, so this costs no forks.
_gtc_prune() {
  emulate -L zsh
  setopt local_options null_glob
  local record
  for record in "$_gtc_live"/*(.); do
    [[ ${record:t} == <-> ]] || continue
    kill -0 ${record:t} 2>/dev/null || rm -f -- "$record"
  done
}

_gtc_record() {
  emulate -L zsh
  mkdir -p "$_gtc_live" 2>/dev/null || return
  print -r -- "$PWD" > "$_gtc_live/$$"
  _gtc_prune
}

# A tab closed on purpose should drop its record; a tab torn down by a quit or
# a restart must keep it, since that record is the whole point. zsh runs zshexit
# for a plain `exit` and for a bare SIGHUP alike, so trap HUP and re-raise it:
# returning 128+signum makes zsh exit down its signal path, which skips zshexit.
# The flag is belt and braces in case a zsh build still runs the hook.
typeset -g _gtc_signalled=0
TRAPHUP() { _gtc_signalled=1; return $(( 128 + 1 )) }

_gtc_forget() {
  emulate -L zsh
  (( _gtc_signalled )) && return
  rm -f "$_gtc_live/$$"
}

_gtc_restore() {
  emulate -L zsh
  local app_pid uptime dir
  app_pid="$(_gtc_app_pid)" || return

  # Check the launch window before touching the queue. Sweeping first means the
  # first shell to load this file long after launch (a fresh install, a cleared
  # state directory) moves the running session's records into a queue nobody
  # will claim from, throwing away the pool it was supposed to protect.
  uptime="$(_gtc_uptime $app_pid)" || return
  (( uptime <= GHOSTTY_TAB_CWD_WINDOW )) || return

  _gtc_open_queue "$app_pid" || return

  # Only a tab still sitting where it started is a candidate. If something has
  # already moved this shell (a `cd` in .localrc, a directory passed on the
  # command line), that was deliberate and wins.
  [[ $PWD == $HOME ]] || return

  dir="$(_gtc_claim)" || return
  cd -- "$dir"
}

# Inspect and prune the saved set.
ghostty-tabs() {
  emulate -L zsh
  setopt local_options null_glob
  local -a records=("$_gtc_live"/*(.om))
  case ${1:-list} in
    list)
      (( $#records )) || { print -r -- "no saved tab directories"; return 0 }
      local record
      for record in $records; do
        printf '%-8s %s\n' "${record:t}" "$(<"$record")"
      done
      ;;
    clear)
      rm -f -- $records
      print -r -- "cleared ${#records} saved tab directories"
      ;;
    *)
      print -ru2 -- "usage: ghostty-tabs [list|clear]"
      return 1
      ;;
  esac
}

# Order matters here. Restore, then record, then start tracking `cd`.
#
# Recording any earlier puts this shell's own record in live/ before the launch
# snapshot sweeps it, so the tab offers its own starting directory back to the
# pool. That is also why the chpwd hook is registered only now: anything that
# cd's during startup (direnv, a `cd` in .localrc) would otherwise record
# through it before the sweep has run.
_gtc_first_prompt() {
  emulate -L zsh
  add-zsh-hook -d precmd _gtc_first_prompt
  _gtc_restore
  _gtc_record
  add-zsh-hook chpwd _gtc_record
}

add-zsh-hook precmd _gtc_first_prompt
add-zsh-hook zshexit _gtc_forget
