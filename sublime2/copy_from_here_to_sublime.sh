#!/bin/sh
# Since Sublime is insane and can't handle symlinks for the User
# directory, we'll need to manually copy stuff over.

sublime_dir=~/Library/Application\ Support/Sublime\ Text\ 2/Packages

# rm -rf $ZSH_DOTFILES/sublime2/User
cp -Rf "$ZSH_DOTFILES/sublime2/User"             "$sublime_dir"
cp -Rf "$ZSH_DOTFILES/sublime2/*.tmTheme" "$sublime_dir/Color Scheme - Default/"
