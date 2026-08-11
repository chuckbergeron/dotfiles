---
name: codex-pr-review
description: >-
  Runs a local Codex code review on the current branch's changes vs main and
  posts the findings as a GitHub PR comment. Replicates the @codex review
  GitHub App experience locally. Use when the user asks to run a Codex review,
  or invoke automatically after creating or updating a PR.
---

# Codex PR Review (local)

Run `codex review` non-interactively against the current branch and post the
result as a GitHub PR comment.

## Preconditions

- `codex` CLI must be installed and authenticated (`codex --version` should work).
- A PR must exist for the current branch (`gh pr view` should return data).
- Run from the repository root.

## 1. Gather PR context

Run in parallel:

```bash
gh pr view --json number,url,title   # PR number and title
git log origin/main..HEAD --oneline  # confirm commits exist to review
```

If there are no commits ahead of main, report "Nothing to review" and stop.

## 2. Run Codex review

Use `codex exec` (not `codex review --base`) because `--base` and a custom prompt are mutually
exclusive in the CLI. `codex exec` accepts a full prompt and can run git commands itself.

```bash
codex exec --sandbox read-only "You are doing a code review. Run this command to get the PR diff: git diff origin/main...HEAD. Then provide a thorough code review with at least 5 specific findings. For each finding include: file path, line number, severity (critical/high/medium/low), a description of the problem, and a concrete suggested fix. Cover bugs, incorrect state management, missing error handling, logic errors, performance issues, and code quality. Do not stop at 1 or 2 items." 2>&1
```

- Capture all stdout and stderr.
- Allow up to 5 minutes. Codex may need time to read files and reason.
- If the command exits non-zero or output is empty, report the error and stop.
- Extract only the findings section from the output (the `## Findings` block through the end). Discard the raw git diff and exec trace lines above it.

## 3. Post review as PR comment

```bash
gh pr comment <number> --body "$(cat <<'EOF'
## Codex Review

<codex review output verbatim>

---
*Local review via `codex review --base main`. Replace with the @codex GitHub App once it is working again.*
EOF
)"
```

Post the full Codex output verbatim inside the comment. Do not summarize or trim it.

## 4. Report back

Return the PR comment URL to the user.

## Notes

- This skill is also called automatically at the end of `/upsert-pr-with-checklist`.
- If `codex` is not found, remind the user: `npm install -g @openai/codex` then authenticate.
- If the PR does not exist yet, ask the user to run `/upsert-pr-with-checklist` first.
