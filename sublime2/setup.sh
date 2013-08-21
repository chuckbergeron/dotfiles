#!/bin/sh
# # Setup a machine for Sublime Text 2
# set -x
#
# # symlink settings in
# sublime_dir=~/Library/Application\ Support/Sublime\ Text\ 2/Packages
#
# # Backup existing settings
# mv "$sublime_dir/User" "$sublime_dir/User.backup"
#
# # Copy theme over
# cp "$ZSH_DOTFILES/sublime2/iLife 05.tmTheme" "$sublime_dir/Color Scheme - Default/"
#
# # Create a symlink between the dotfiles dir and the Sublime Prefs
# ln -s "$ZSH_DOTFILES/sublime2/User" "$sublime_dir"
#
# # Grab the Soda theme (write an 'unless already installed')
# # cd "$sublime_dir"
# # git clone https://github.com/buymeasoda/soda-theme/ "Theme - Soda"
