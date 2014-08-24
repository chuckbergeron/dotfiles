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

alias drop_dbs="rake db:drop:all"
alias create_dbs="rake db:create:all"
alias migrate_dbs="rake db:migrate && rake db:migrate RAILS_ENV='test'"
alias seed_dbs="rake db:seed"
alias reload_dbs="drop_dbs && create_dbs && migrate_dbs && rake db:dev_setup"
alias reload_handcrafted='drop_dbs && create_dbs && migrate_dbs && seed_dbs'

# Capiche is a plug-in written for Capistrano
alias pull_remote_db="cap capiche:db:mirror && cap capiche:db:import"

# Zeus
alias zs="zeus s"
alias zscafe="zeus s -b127.0.0.1"
alias zc="zeus c"
