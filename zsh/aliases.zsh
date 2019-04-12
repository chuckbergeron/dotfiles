# alias ep="$EDITOR ~/.zshrc"
# alias rp='. ~/.zshrc'
alias ed="$EDITOR ~/.dotfiles"
alias h="history"
alias ls="ls -Al"

alias reload_dotfiles="cd ~/.dotfiles && rake install"

# Dir navigation aliases, to be replaced by z:
# https://github.com/rupa/z
alias cdr="cd ~/Repo"
alias cdg="cd ~/Git"

# \cat # ignore aliases named "cat" - explanation: https://stackoverflow.com/a/16506263/22617
# command cat # ignore functions and aliases

alias cat="bat"
alias ping="prettyping --nolegend"
alias top="htop"
alias find="fd"
alias du="ncdu --color dark -rr -x --exclude .git --exclude node_modules"
# alias du="nnn"
alias man="tldr"
# alias grep="ack"
