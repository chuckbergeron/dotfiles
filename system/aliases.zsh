alias ....="cd ../../.."
alias kill_core_audio="sudo kill `ps -ax | grep 'coreaudiod' | grep 'sbin' |awk '{print $1}'`"

alias enable_spotlight_indexing="sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist"
alias disable_spotlight_indexing="sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist"

alias et="code ."

# Project shortcuts live in ~/.localrc, which stays out of this public repo.
