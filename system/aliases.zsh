# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
if $(gls &>/dev/null)
then
  alias ls="gls -F --color"
  alias l="gls -lAh --color"
  alias ll="gls -l --color"
  alias la='gls -A --color'
fi

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
