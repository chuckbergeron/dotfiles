alias gfetch="git co master && git fetch && git pull --rebase"
alias gpo="git push origin"
alias prune_local_branches="git branch --merged master | grep -v 'master$' | xargs git branch -d"
