# Drop a single stale host key rather than rewriting the whole file:
#   forget_host github.com
forget_host() {
  ssh-keygen -R "$1"
}

# Pipe my public key to my clipboard.
alias pubkey="pbcopy < ~/.ssh/id_ed25519.pub && echo '=> Public key copied to pasteboard.'"