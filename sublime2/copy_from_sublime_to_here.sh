#!/bin/sh
# Since Sublime is insane and can't handle symlinks for the User
# directory, we'll need to manually copy stuff over.

sublime_dir=~/Library/Application\ Support/Sublime\ Text\ 2/Packages

rm -rf $ZSH_DOTFILES/sublime2/User
cp -R "$sublime_dir/User" "$ZSH_DOTFILES/sublime2/User"
