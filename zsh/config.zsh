# if [[ -n $SSH_CONNECTION ]]; then
#   export PS1='%m:%3~$(git_info_for_prompt)%# '
# else
#   export PS1='%3~$(git_info_for_prompt)%# '
# fi

export EDITOR="atom"

export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="wedisagree"

autoload -U $ZSH_DOTFILES/zsh/functions/*(:t)

HISTFILE=~/.histfile
HISTSIZE=SAVEHIST=10000

# Vim style shortcuts
bindkey -v

# don't nice background tasks
setopt NO_BG_NICE

setopt NO_HUP

setopt NO_LIST_BEEP

setopt LOCAL_OPTIONS

# allow functions to have local options
setopt LOCAL_TRAPS

# allow functions to have local traps
setopt HIST_VERIFY

# add timestamps to history
setopt EXTENDED_HISTORY

setopt PROMPT_SUBST

#setopt CORRECT
unsetopt correct
unsetopt correct_all

# More extensive tab completion.
setopt COMPLETE_IN_WORD
setopt IGNORE_EOF

# adds history
setopt APPEND_HISTORY

# adds history incrementally and share it across sessions
setopt INC_APPEND_HISTORY SHARE_HISTORY

# don't record dupes in history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS

setopt autocd

# Special character matching, ssuch as /*.txt
setopt extendedglob
unsetopt caseglob
setopt completeinword

# don't expand aliases _before_ completion has finished
#   like: git comm-[tab]
setopt complete_aliases

zle -N newtab

bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[[5D' beginning-of-line
bindkey '^[[5C' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[^N' newtab
bindkey '^?' backward-delete-char
