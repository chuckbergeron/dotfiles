---
name: upsert-pr-with-checklist
description: >-
  Creates or updates a GitHub pull request with a standard changelog, summary (≤3
  bullets), merge checklist, and mandatory @codex review in the PR body and as a
  comment. Use when the user asks to open a PR, create a pull request, or run
  this skill by name.
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

## 4. Trigger Codex review (only on update)

After update, **always** post a PR comment:

```bash
gh pr comment <number-or-url> --body "@codex review"
```

## 5. Report back

Return the PR URL to the user.

Do not push with `--force` to `main`/`master` unless the user explicitly asks.

## Verification

- [ ] PR body has Changelog, Summary, Checklist (verbatim), and `@codex review`
- [ ] At most 3 summary bullets
- [ ] Separate PR comment: `@codex review`
- [ ] User received the PR link
