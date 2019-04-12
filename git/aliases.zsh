alias gfetch="git co master && git fetch && git pull --rebase"
alias gpo="git push origin"
# alias prune_local_branches="git branch --merged master | grep -v 'master$' | xargs git branch -d"
prune_branches_like() {
    git branch --merged $1 | grep -v "\*\|$1" | xargs -n 1 git branch -d
}
alias prune_like_master="prune_branches_like master"
alias prune_like_develop="prune_branches_like develop"
alias prune_like_staging="prune_branches_like staging"
