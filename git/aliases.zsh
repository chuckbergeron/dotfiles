alias g="git"
alias gfetch="git co master; git co main; git fetch && git pull --rebase"
alias gpo="git push origin"
prune_gone_branches_like() {
  git fetch --prune
  git branch -vv | grep ': gone]' | awk '{print $1}' | xargs git branch -D
}
alias prune_like_master="prune_gone_branches_like master"
alias prune_like_main="prune_gone_branches_like main"
alias prune_like_develop="prune_gone_branches_like develop"
alias prune_like_staging="prune_gone_branches_like staging"
