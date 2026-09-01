alias ni='npm install'
alias nig='npm install -g'
alias nrs='npm run start'
# nrd                       -> npm run dev (or "nrd web" in an apps/web workspace)
# nrd web                   -> pnpm --filter "*web" dev
# nrd telegram              -> pnpm --filter "*telegram" dev
# nrd --filter @megapot/web -> pnpm --filter @megapot/web dev
nrd() {
  rm -rf .next apps/web/.next apps/telegram/.next || return
  local target=$1
  # pnpm workspaces with an apps/web package have no runnable root dev script
  if [[ -z $target && -f pnpm-workspace.yaml && -d apps/web ]]; then
    target=web
  fi
  # A git worktree needs its own install. Next/Turbopack pins the workspace root
  # to the nearest lockfile, so it will not resolve the main checkout's
  # node_modules no matter what is on PATH. Detect a missing or half-finished
  # install and repair it, clearing the workspace-state file first: an
  # interrupted install leaves it claiming everything is up to date, which makes
  # a plain `pnpm install` no-op over an empty tree.
  local -a installed_bins
  installed_bins=(node_modules/.bin/*(N))
  if [[ -f pnpm-workspace.yaml ]] && (( ${#installed_bins} == 0 )); then
    echo "nrd: no local install in $PWD, running pnpm install" >&2
    rm -f node_modules/.pnpm-workspace-state-v1.json
    pnpm install || return
  fi
  if [[ -z $target ]]; then
    npm run dev
  elif [[ $target == -* ]]; then
    pnpm "$@" dev
  else
    pnpm --filter "*$target" dev
  fi
}
alias nrb='npm run build'
alias naf='npm audit fix'
alias nu='npm update'
alias nt='npm test'

alias li='npm run lint'
alias lf='npm run lint:fix'
alias fo='npm run lint'
alias ff='npm run format:fix'

alias ys="yarn start"
alias yd="yarn dapp"
alias yl="yarn lambda"

alias da="direnv allow"
