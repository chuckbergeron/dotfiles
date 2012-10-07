## dotfiles

This is originally the fantastic work of [Zach Holman](http://zachholman.com/2010/08/dotfiles-are-meant-to-be-forked/), forked and customized . This covers my usual tools: OSX, zsh, Ruby, Rails, rvm, git, mysql, pg, homebrew, sublime.

## install

I'd suggest forking your own version, first. Then, run the following:

```sh
git clone https://github.com/$your_username/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap
```

This will symlink the appropriate files in `.dotfiles` to your home directory.
Everything is configured and tweaked within `~/.dotfiles`, though.

Read the full docs here:
https://github.com/holman/dotfiles
