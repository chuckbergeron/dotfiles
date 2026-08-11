#!/usr/bin/env python3
"""
Blocks em dashes and prose semicolons before Claude writes them.

Em dashes and en dashes: blocked everywhere.
Semicolons: blocked in .md files, git commit messages, and // comments in code files.
Non-breaking spaces (U+00A0): blocked from being stripped in Edit operations.
"""

import json
import re
import sys

NBSP = " "
# Build the pattern from ordinals so the literal characters do not appear in this source file.
EMDASH_RE = re.compile("[" + chr(0x2014) + chr(0x2013) + "]")

data = json.load(sys.stdin)
tool_name = data.get("tool_name", "")
tool_input = data.get("tool_input", {})

# Collect (text, label) pairs to check
checks = []

if tool_name == "Write":
    checks.append((tool_input.get("content", ""), tool_input.get("file_path", "file")))

elif tool_name == "Edit":
    checks.append((tool_input.get("new_string", ""), tool_input.get("file_path", "file")))

elif tool_name == "Bash":
    command = tool_input.get("command", "")
    if "git commit" in command:
        checks.append((command, "git commit"))

violations = []

# Guard: block edits that strip non-breaking spaces (U+00A0)
if tool_name == "Edit":
    old_s = tool_input.get("old_string", "")
    new_s = tool_input.get("new_string", "")
    if NBSP in old_s and old_s.count(NBSP) > new_s.count(NBSP):
        violations.append(
            f"non-breaking space stripped in {tool_input.get('file_path', 'file')}:\n"
            "    old_string contains U+00A0 but new_string drops it.\n"
            "    Copy the non-breaking space character into new_string to preserve it."
        )

for text, label in checks:
    # Em and en dashes: never acceptable in prose
    if EMDASH_RE.search(text):
        hits = [line.strip() for line in text.splitlines() if EMDASH_RE.search(line)]
        violations.append(
            f"em/en dash in {label}:\n"
            + "\n".join(f"    {h}" for h in hits[:3])
            + ("\n    ..." if len(hits) > 3 else "")
        )

    # Semicolons in prose contexts only
    is_md = label.endswith(".md")
    is_commit = label == "git commit"

    if is_md or is_commit:
        # All semicolons are suspect in markdown and commit messages
        hits = [line.strip() for line in text.splitlines() if ";" in line]
        if hits:
            violations.append(
                f"semicolon in {label}:\n"
                + "\n".join(f"    {h}" for h in hits[:3])
                + ("\n    ..." if len(hits) > 3 else "")
            )
    else:
        # Code files: only flag semicolons inside // comments
        hits = [
            line.strip()
            for line in text.splitlines()
            if re.match(r"\s*//", line) and ";" in line
        ]
        if hits:
            violations.append(
                f"semicolon in // comment in {label}:\n"
                + "\n".join(f"    {h}" for h in hits[:3])
                + ("\n    ..." if len(hits) > 3 else "")
            )

if violations:
    print("STYLE VIOLATION: no em dashes or semicolons in prose.", file=sys.stderr)
    print("Replace em dashes with commas or reword. Replace semicolons with commas or periods.\n", file=sys.stderr)
    for v in violations:
        print(f"  {v}\n", file=sys.stderr)
    sys.exit(2)

sys.exit(0)
