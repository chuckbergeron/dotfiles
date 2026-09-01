## Dotfiles

Originally, this is the fantastic work of [Zach Holman](http://zachholman.com/2010/08/dotfiles-are-meant-to-be-forked/), forked and customized . This covers my usual tools: OSX, zsh, Ruby, Rails, rvm, git, mysql, pg, homebrew, sublime.

### Installation

I'd suggest forking your own version, first. Then, run the following:

```sh
git clone https://github.com/$your_username/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap
```

If it bombs, complaining about a missing Rakefile, run `rake install` from the ~/.dotfiles directory.

This will symlink the appropriate files in `.dotfiles` to your home directory.
Everything is configured and tweaked within `~/.dotfiles`, though.

### Additionals

##### Set custom OSX defaults

$ `sh ~/osx/set-defaults.sh`

##### Mucho betta Terminal theme

$ `open ~/osx/charles.terminal`

To use this new theme as the default, open Terminal's settings and make 'charles' the default.

### Ghostty tab directories

`window-save-state = always` in `ghostty/config` reopens windows, tabs and
splits after a restart, but Ghostty starts every restored shell in the default
directory. `zsh/ghostty-tab-cwd.zsh` closes that gap: it records each tab's cwd
as it changes and hands the saved directories back to the tabs Ghostty reopens.
It is sourced automatically by the `**/*.zsh` loop in `zsh/zshrc.symlink`, so
there is nothing to enable.

Restored tabs get the saved *set* of directories rather than a
position-to-directory mapping, because a restored surface carries no identity
across a restart. `ghostty-tabs` lists the saved set and `ghostty-tabs clear`
empties it.

### AI tool config

`claude-code/`, `cursor/` and `ghostty/` are symlinked into place by the
`install_config` rake task, which `rake install` runs first. Targets are listed
in `XDG_LINKS` at the top of the Rakefile. Add a line per new app.

Claude Code runs under two accounts here (`~/.claude` for work,
`~/.claude-personal`). Settings, skills and memory are tracked separately per
account so the two stay isolated. `CLAUDE.md` is one file linked into both.

**This repo is public, so only hand-authored config is tracked.** The following
are deliberately excluded and should stay that way:

- `~/.claude.json` and `~/.codex/auth.json`, which hold account and OAuth credentials
- `~/.cursor/mcp.json`, which contains a plaintext MCP API key
- `~/.codex/config.toml`, which has local absolute paths and private project names
- session state everywhere else: `history.jsonl`, `projects/`, `sessions/`,
  `file-history/`, `plans/`, `shell-snapshots/`, `telemetry/`, every `*cache*`
- `~/.cursor/skills-cursor/`, which ships with Cursor rather than being ours

The `autoMode` block in both settings files is deliberately untracked. Auto mode
reads it only from `~/.claude/settings.json`, so it cannot live in a local
override file, and its `environment` list names private repos, internal hosts,
local paths and secret variable names. Both files therefore carry
`git update-index --skip-worktree`, which keeps the real config on disk while
git ignores changes to it. To commit a genuine settings change:

```sh
git update-index --no-skip-worktree claude-code/settings.json
# edit, strip autoMode from the staged copy, commit, restore it on disk
git update-index --skip-worktree claude-code/settings.json
```

Note that `memory/` is written by Claude Code at runtime, so new memories land
in this working tree. Read them before committing.

### Further Reading

Read the full docs here:
https://github.com/holman/dotfiles
