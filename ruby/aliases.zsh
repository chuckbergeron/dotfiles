alias b="bundle"
alias r="bundle exec rails"
alias rs="bundle exec rails server thin --debugger"
alias rscafe="bundle exec rails server -b127.0.0.1 thin --debugger"
#alias g="git"

alias c2="cap deploy"
alias c2mig="cap deploy:migrate"

alias follow_dev_log="tail -f log/development.log"
alias grep_for_git_merge_conflicts="grep \" HEAD\" * -r --color"

edit_rvm_gems() {
  rvm gemdir | xargs subl
}
