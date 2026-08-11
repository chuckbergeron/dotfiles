---
name: upsert-pr-with-checklist
description: >-
  Creates or updates a GitHub pull request with a standard changelog, summary (≤3
  bullets), merge checklist, and mandatory @codex review in the PR body. Posts a
  separate @codex review comment only when updating an existing PR. Use when the
  user asks to open a PR, create a pull request, or run this skill by name.
---

# Create PR with checklist and Codex review

Open (or update) a GitHub PR using `gh`. **Always** include the checklist and **`@codex review`** — never omit Codex.

## Preconditions

- Run from the repository root.
- User must be able to use GitHub CLI (`gh auth login` if needed).
- Branch should be pushed before `gh pr create` (`git push -u origin HEAD` when no upstream).

## 1. Gather context (parallel)

Run in parallel:

- `git status`
- `git diff` (staged and unstaged)
- `git branch -vv` (upstream tracking)
- `git log origin/main..HEAD --oneline` (or the repo’s default base branch if not `main`)
- `git diff origin/main...HEAD` (full PR diff)

If a PR already exists for the current branch: `gh pr view --json number,url,title,body`

## 2. Draft the PR body

Use this structure exactly. Keep it short.

```markdown
## Changelog

<One or two sentences: what changed for users or operators.>

## Summary

<One sentence: why this PR exists.>

- <Bullet 1 — most important change>
- <Bullet 2>
- <Bullet 3 — omit if not needed; never more than 3>

## Checklist

- [ ] Update the changelog
- [ ] Perform a manual code review
- [ ] Run an AI code review
- [ ] Ensure the Vercel build is green
- [ ] Resolve all merge conflicts
- [ ] Run linting and type checks locally with no warnings
- [ ] Desktop QA
- [ ] Mobile QA

---

@codex review
```

Rules:

- **Changelog** and **Summary** are required; bullets are optional but capped at **3**.
- The **Checklist** block and the line **`@codex review`** after `---` are **required verbatim** — do not reword, remove, or make Codex optional.
- Title: concise, conventional when it fits (e.g. `Short description`). Include ticket id (e.g. as `ENG [ID#]`) if the branch or user context references one.

## 3. Create or update the PR

### New PR

```bash
git push -u origin HEAD   # only if branch has no upstream or is behind remote

gh pr create --base main --title "..." --body "$(cat <<'EOF'
<paste full body from step 2>
EOF
)"
```

Use the repo’s actual default base branch if not `main`.

### Existing PR

```bash
gh pr edit --body "$(cat <<'EOF'
<paste full body from step 2>
EOF
)"
```

Or `gh pr edit --body-file .pr-body.md` after writing the body to a temp file in the repo.

## 4. Trigger Codex review (existing PR updates only)

**Only when updating an existing PR** (i.e. `gh pr edit` was used), post a follow-up comment so Codex re-reviews the new changes:

```bash
gh pr comment <number-or-url> --body "@codex review"
```

**Do not post this comment for new PRs.** The `@codex review` line is already in the PR body, and Codex will pick it up automatically.

## 5. Run local Codex review

After the PR is created or updated, always run the local Codex review by invoking the `codex-pr-review` skill:

```bash
codex exec --sandbox read-only "You are doing a code review. Run this command to get the PR diff: git diff origin/main...HEAD. Then provide a thorough code review with at least 5 specific findings. For each finding include: file path, line number, severity (critical/high/medium/low), a description of the problem, and a concrete suggested fix. Cover bugs, incorrect state management, missing error handling, logic errors, performance issues, and code quality. Do not stop at 1 or 2 items." 2>&1
```

Note: use `codex exec` rather than `codex review --base` because the `--base` flag and a custom prompt are mutually exclusive in the CLI. Extract only the findings section from the output before posting.

Capture the output and post it as a PR comment:

```bash
gh pr comment <number> --body "$(cat <<'EOF'
## Codex Review

<codex review output verbatim>

---
*Local review via `codex review --base main`. Replace with the @codex GitHub App once it is working again.*
EOF
)"
```

- Allow up to 5 minutes for Codex to run.
- If the output is empty or the command fails, report the error but do not block the PR workflow.
- Post the full output verbatim. Do not summarize or trim it.

## 6. Report back

Return the PR URL and the Codex review comment URL to the user.

Do not push with `--force` to `main`/`master` unless the user explicitly asks.

## Verification

- [ ] PR body has Changelog, Summary, Checklist (verbatim), and `@codex review`
- [ ] At most 3 summary bullets
- [ ] Separate `@codex review` comment posted only if this was an existing PR update (not a new PR)
- [ ] Local Codex review ran and was posted as a PR comment
- [ ] User received the PR link and review comment URL
