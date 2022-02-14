alias ....="cd ../../.."
alias kill_core_audio="sudo kill `ps -ax | grep 'coreaudiod' | grep 'sbin' |awk '{print $1}'`"

alias enable_spotlight_indexing="sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist"
alias disable_spotlight_indexing="sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist"

alias et="code ."

alias builder="cd ~/Git/crypto/pool-together/pooltogether-pool-builder-ui"
alias community="cd ~/Git/crypto/pool-together/pooltogether-community-ui"
alias ref="cd ~/Git/crypto/pool-together/pooltogether-community-ui"
alias flagship="cd ~/Git/crypto/pool-together/pool-app"
alias vote="cd ~/Git/crypto/pool-together/pooltogether-governance-ui"
alias gov="cd ~/Git/crypto/pool-together/pooltogether-governance-ui"
alias pods="cd ~/Git/crypto/pool-together/pooltogether-pods-ui"
alias api="cd ~/Git/crypto/pool-together/api"
alias hooks="cd ~/Git/crypto/pool-together/pooltogether-hooks"
alias utils="cd ~/Git/crypto/pool-together/pooltogether-utilities"
alias components="cd ~/Git/crypto/pool-together/pooltogether-react-components"
