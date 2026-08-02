export PATH=~/Dropbox/bin:./bin:$PATH

# Binary Paths
export PATH=/usr/local/bin:/bin:/usr/bin:/usr/sbin:/sbin:/usr/local/git/bin:/usr/texbin
export PATH=$PATH:/usr/X11/bin:/opt/local/bin:/opt/local/sbin:/usr/local/sbin:$HOME/bin

# OpenSSL Path
export PATH=/usr/local/opt/openssl/bin:$PATH

# NPM
export PATH=$PATH:./node_modules/.bin
# alias npm-exec='PATH=$(npm bin):$PATH'

# BREW — must come before /usr/bin so Homebrew tools (incl. python3) win
export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$PATH

# Make `python3`/`pip3` resolve to Homebrew's python@3.12 (needed by ledfx)
export PATH=/opt/homebrew/opt/python@3.12/libexec/bin:$PATH
