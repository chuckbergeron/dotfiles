alias prune_local_branches="git branch --merged master | grep -v 'master$' | xargs git branch -d"
