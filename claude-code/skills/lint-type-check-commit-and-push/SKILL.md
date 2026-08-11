---
name: lint-type-check-commit-and-push
description: Runs Biome lint with auto-fix, resolves remaining lint issues, runs TypeScript type-check and fixes errors, then creates a short conventional commit and pushes. Use when the user asks to lint and push, run pre-commit quality checks, fix Biome/tsc and ship, or invokes this skill by name.
---

# Lint, type-check, commit, and push

End-to-end workflow: **lint fix → clean lint → type-check → clean types → commit → push**.

## Preconditions

- Run from the repository root (or `cd` there first).
- Detect the package manager: prefer `pnpm` if `pnpm-lock.yaml` exists, else `yarn` if `yarn.lock`, else `npm`.
- Read `package.json` `scripts` and use the project’s names if they differ (this repo: `lint:fix`, `type-check`).

## 1. Lint (Biome)

1. Run the lint fix script, e.g. `pnpm run lint:fix` (here: `biome check --write .`).
2. If the command still exits non-zero or prints remaining diagnostics:
   - Read the reported files and line ranges.
   - Apply minimal edits until `pnpm run lint` (or `pnpm run lint:fix`) completes successfully with no unfixed issues.

Do not skip manual fixes Biome cannot apply automatically.

## 2. Type-check

1. Run `pnpm run type-check` (here: `tsc --noEmit`).
2. For each error: fix types, imports, or code in the smallest reasonable change.
3. Re-run until `type-check` exits 0.

## 3. Commit

1. `git status` — confirm only intended files are included.
2. Stage changes: `git add` for the paths that belong in this commit (typically all modified files for this workflow: `git add -A` when appropriate).
3. Write a **short** commit message:
   - One line subject, ~50–72 characters when possible.
   - Optional body only if needed for clarity.
   - Prefer `type(scope): summary` when it fits the repo (e.g. `fix: align round types`, `chore: lint and types`).
4. `git commit -m "..."`

If there is nothing to commit after lint/type fixes, say so and skip commit/push.

## 4. Push

1. `git push` (current branch).
2. If the branch has no upstream, use `git push -u origin <branch>` once.

Stop before `git push` if the user explicitly asked not to push or only to prepare a commit.

## Verification checklist

- [ ] `lint:fix` (and/or `lint`) succeeds with no remaining actionable issues
- [ ] `type-check` exits 0
- [ ] Commit message is short and describes the change
- [ ] Push succeeded or the failure reason is reported (auth, conflicts, protected branch)

## Notes

- Do not run destructive git commands (`reset --hard`, `push --force`) unless the user explicitly requests them.
- If `lint:fix` and `type-check` both pass but pre-commit hooks modify files, re-run lint/type-check after the hook runs, then commit again if needed.
