# Claude Code Rules

## Git Worktrees

Always create worktrees inside the `.worktrees/` subdirectory of the current project so they stay within the project's permission scope and are co-located with the main checkout.

```sh
# Pattern to follow
git worktree add .worktrees/<branch-name>

# Example
git worktree add .worktrees/my-feature-branch
```

Never create worktrees at sibling paths (e.g. `../project-name-suffix`) or arbitrary locations outside the project root.
