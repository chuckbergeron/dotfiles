#!/usr/bin/env python3
"""Set the macOS desktop AND lock screen wallpaper.

macOS keeps two settings per display/space: "Desktop" and "Idle" (lock screen).
AppleScript writes only the Desktop branch, and does it asynchronously via
WallpaperAgent -- so a read-modify-write against the plist races that agent.
This writes both branches directly instead, then restarts the agent.
"""
import os, plistlib, subprocess, sys, urllib.parse

STORE = os.path.expanduser(
    "~/Library/Application Support/com.apple.wallpaper/Store/Index.plist")

def build_config(path):
    url = "file://" + urllib.parse.quote(os.path.abspath(path))
    return plistlib.dumps({"type": "imageFile", "url": {"relative": url}},
                          fmt=plistlib.FMT_BINARY)

def apply(node, cfg):
    """Set Configuration on every Desktop and Idle branch in the tree."""
    n = 0
    if isinstance(node, dict):
        for branch in ("Desktop", "Idle"):
            b = node.get(branch)
            if isinstance(b, dict):
                try:
                    b["Content"]["Choices"][0]["Configuration"] = cfg
                    n += 1
                except (KeyError, IndexError, TypeError):
                    pass
        for v in node.values():
            n += apply(v, cfg)
    return n

def current(node, out):
    if isinstance(node, dict):
        for branch in ("Desktop", "Idle"):
            b = node.get(branch)
            if isinstance(b, dict):
                try:
                    c = plistlib.loads(b["Content"]["Choices"][0]["Configuration"])
                    out.setdefault(branch, set()).add(
                        urllib.parse.unquote(c["url"]["relative"]).rsplit("/", 1)[-1])
                except Exception:
                    pass
        for v in node.values():
            current(v, out)
    return out

def main():
    if len(sys.argv) < 2:
        sys.exit("usage: set-wallpaper.py <image-path>")
    img = os.path.abspath(sys.argv[1])
    if not os.path.isfile(img):
        sys.exit("No such image: " + img)

    root = plistlib.load(open(STORE, "rb"))
    count = apply(root, build_config(img))
    if not count:
        sys.exit("Found no wallpaper slots to write; is the store initialised?")
    plistlib.dump(root, open(STORE, "wb"), fmt=plistlib.FMT_BINARY)
    subprocess.run(["killall", "WallpaperAgent"],
                   stderr=subprocess.DEVNULL, check=False)

    # Verify against what is actually on disk, not what we intended.
    got = current(plistlib.load(open(STORE, "rb")), {})
    want = os.path.basename(img)
    ok = all(v == {want} for v in got.values()) and set(got) == {"Desktop", "Idle"}
    for branch in sorted(got):
        print("%-8s -> %s" % (branch, ", ".join(sorted(got[branch]))))
    if not ok:
        sys.exit("Verification failed: expected %s on both branches." % want)
    print("Set desktop + lock screen: %s (%d slots)" % (want, count))

main()
