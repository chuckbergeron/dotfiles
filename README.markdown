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

### Further Reading

Read the full docs here:
https://github.com/holman/dotfiles
