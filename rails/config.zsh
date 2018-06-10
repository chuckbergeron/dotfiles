export ENVIRONMENT=development
export EDITOR="subl -n"

export RUBY_GC_MALLOC_LIMIT=79000000
export RUBY_GC_MALLOC_LIMIT=100000000
export RUBY_GC_HEAP_INIT_SLOTS=40000
export RUBY_GC_HEAP_FREE_SLOTS=200000

export RUBY_HEAP_FREE_MIN=100000
export RUBY_HEAP_SLOTS_INCREMENT=300000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1


alias be="bundle exec "
alias bc="bundle check"
alias elm="ls db/migrate/* | tail -n1 | xargs $EDITOR"

alias drop_dbs="rails db:drop:all"
alias create_dbs="rails db:create:all"
alias migrate_db="rails db:migrate"
alias seed_dbs="rails db:seed"
alias reload_dbs="drop_dbs && create_dbs && migrate_dbs && rails db:dev_setup"

# Capiche is a plug-in written for Capistrano
alias pull_remote_db="cap capiche:db:mirror && cap capiche:db:import"

# Zeus
alias zs="zeus s"
alias zscafe="zeus s -b127.0.0.1"
alias zc="zeus c"
