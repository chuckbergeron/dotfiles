export ENVIRONMENT=development
# export RAILS_ENV=development
export EDITOR="subl"

export RUBY_HEAP_MIN_SLOTS=800000
export RUBY_HEAP_FREE_MIN=100000
export RUBY_HEAP_SLOTS_INCREMENT=300000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=79000000

alias rake_pure="/usr/bin/rake"
#alias rake="bundle exec rake"
#alias guard="bundle exec guard"

# Short for Rails Autotest
#alias rat="bundle exec rake"
#alias ss="./script/server --debugger"
#alias sc="./script/console"
alias bis="bundle install --binstubs"
alias migdb="rake db:migrate && rake db:migrate RAILS_ENV='test'"
alias seeddb="rake db:seed"
alias reload_db="rake db:migrate:reset && rake db:seed"

# Capiche is a plug-in written for Capistrano
alias pull_remote_db="cap capiche:db:mirror && cap capiche:db:import"

alias glocal="gem list --local"

alias 186="rvm use system"
alias 187="rvm use 1.8.7-p330"
alias 191="rvm use 1.9.1-p376"
alias 192="rvm use 1.9.2-head"
