alias gfetch="git co master && git fetch && git pull --rebase"
alias prune_local_branches="git branch --merged master | grep -v 'master$' | xargs git branch -d"
