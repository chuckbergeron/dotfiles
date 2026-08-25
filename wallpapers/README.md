# wallpapers

A curated set of 36 wallpapers (4K and up) plus a switcher that sets the macOS
desktop **and** lock screen together.

```sh
./fetch.sh                                  # download the set to ~/Pictures/Wallpapers
~/Pictures/Wallpapers/set-wallpaper.sh 14   # switch by number
~/Pictures/Wallpapers/set-wallpaper.sh      # random
./rotation.sh install                       # auto-rotate every 6 hours
```

## Rotation

`rotation.sh` manages a launchd agent that picks a random wallpaper on a timer.

```sh
./rotation.sh install       # every 6 hours (the default)
./rotation.sh install 12    # or any other interval, in hours
./rotation.sh status        # is it loaded, what fired last
./rotation.sh run           # fire once, right now
./rotation.sh uninstall
```

macOS has no user cron worth relying on for GUI work. launchd is the supported
mechanism, and unlike cron it catches up on a fire it missed while the machine
was asleep, which matters for a 6 hour interval on a laptop.

`RunAtLoad` is off, so logging in does not itself change the wallpaper. Random
selection never picks the wallpaper that is already set, tracked in a `.last`
file alongside the images. Output goes to `~/Library/Logs/wallpaper-rotate.log`.

## The image files are not in this repo, on purpose

`manifest.json` records each wallpaper's name, source URL, resolution and
SHA-256. `fetch.sh` re-downloads them. Two reasons it works this way.

**Licensing.** The images come from wallhaven.cc, which is a user-upload site.
It carries no per-file license metadata, and the uploads are overwhelmingly
third-party work, meaning photographs and digital art belonging to their
creators, with at least one of Apple's stock macOS wallpapers in the mix. Using
them as a desktop background is ordinary personal use. Committing the files to
**this repo, which is public**, is redistribution, and nothing about the source
grants that. So the repo stores the pointers, not the pixels.

If you ever want the actual files version-controlled, put them in a private
repo or private object storage. That is still copying, but it is not
publishing, which is the part that matters here.

**Size.** The set is about 159 MB of binaries that would be committed again on
every re-crop or re-encode. Git handles that badly and it would dominate the
repo.

Because the sources are third-party URLs, they can rot. `fetch.sh` reports any
entry that fails or whose checksum no longer matches, rather than silently
installing something different.

## Why set-wallpaper.py exists

macOS stores two wallpaper settings per display and space, `Desktop` and `Idle`
(the lock screen), in

```
~/Library/Application Support/com.apple.wallpaper/Store/Index.plist
```

The usual AppleScript one-liner (`tell application "System Events" to set
picture of every desktop...`) writes only the `Desktop` branch, so the lock
screen silently keeps whatever it had. It also writes *asynchronously* via
`WallpaperAgent`, so reading the plist straight afterwards races that write. A
read-modify-write against the plist can therefore pick up the stale tree and
clobber the change that was just made.

`set-wallpaper.py` writes both branches directly, restarts `WallpaperAgent`,
then re-reads the plist to confirm what actually landed. It exits non-zero if
the result does not match what was asked for.

## Files

| File | Purpose |
| --- | --- |
| `manifest.json` | The set: numbers, names, source URLs, checksums |
| `fetch.sh` | Downloads the set, verifies checksums, installs the scripts |
| `set-wallpaper.py` | Sets desktop and lock screen, with verification |
| `set-wallpaper.sh` | Number-to-file wrapper, and random selection |
| `rotation.sh` | Installs and manages the launchd rotation agent |

## Rake

```sh
rake wallpapers   # fetch the images, then install the rotation agent
```

This module installs to `~/Pictures/Wallpapers` rather than a dotfile path, so
it is not part of `XDG_LINKS` and gets its own task. That task is deliberately
not a dependency of `rake install`. It pulls about 159 MB over the network, so
setting up a fresh machine should not trigger it silently. Both halves are
idempotent, so re-running it is cheap.
