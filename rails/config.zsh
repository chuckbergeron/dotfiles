export ENVIRONMENT=development
export EDITOR="subl -w"

export RUBY_HEAP_MIN_SLOTS=800000
export RUBY_HEAP_FREE_MIN=100000
export RUBY_HEAP_SLOTS_INCREMENT=300000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=79000000
export RUBY_FREE_MIN=200000

alias rake_pure="/usr/bin/rake"
alias edit_last_migration="ls db/migrate/* | tail -n1 | xargs $EDITOR"

#alias rake="bundle exec rake"
#alias guard="bundle exec guard"

# Short for Rails Autotest
#alias rat="bundle exec rake"
#alias ss="./script/server --debugger"
#alias sc="./script/console"

alias bc="bundle check"
alias bis="bundle install --binstubs"
alias drop_dbs="rake db:drop:all"
alias create_dbs="rake db:create:all"
alias migrate_dbs="rake db:migrate && rake db:migrate RAILS_ENV='test'"
alias reload_dbs="drop_dbs && create_dbs && migrate_dbs && rake db:dev_setup"
alias seed_dbs="rake db:seed"

# Capiche is a plug-in written for Capistrano
alias pull_remote_db="cap capiche:db:mirror && cap capiche:db:import"

alias glocal="gem list --local"

# Zeus
alias zs="zeus s"
alias zc="zeus c"