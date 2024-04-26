# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# go
export GOPATH=$HOME/go
export PATH=$HOME/go/bin:$PATH

# nodebrew
export PATH=$HOME/.nodebrew/current/bin:$PATH
export PATH=$HOME/.config/yarn/global/node_modules/.bin:$PATH

# rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# peco
function peco-history-selection() {
    BUFFER=$(history 1 | sort -k1,1nr | perl -ne 'BEGIN { my @lines = (); } s/^\s*\d+\*?\s*//; $in=$_; if (!(grep {$in eq $_} @lines)) { push(@lines, $in); print $in; }' | peco --query "$LBUFFER")
    CURSOR=${#BUFFER}
    zle reset-prompt
}
zle -N peco-history-selection
bindkey '^R' peco-history-selection

# gettext, envsubst
export PATH="/usr/local/opt/gettext/bin:$PATH"

# alias
alias g='git'
alias gb='git branch'
alias gc='git commit'
alias gco='git checkout'
alias gd='git diff'
alias gp='git push'
alias gr='git rebase'
alias gs='git status'
alias yfc='yarn force-commit'

alias git_default_branch="git symbolic-ref --short refs/remotes/origin/HEAD | awk -F'[/]' '{print \$NF}'"

function gpush() {
  cb=$(git branch --show-current)
  if [[ $cb =~ "$(whoami)/.*" ]]; then
    echo "# git push origin $cb $@"
    git push origin $cb $@
  else
    echo "error: branch '$cb' may not be your branch." >&2
    return 1
  fi
}

function gopen() {
  cb=$(git branch --show-current)
  default_branch=$(git_default_branch)
  if [[ $cb =~ "$(whoami)/.*" ]]; then
    echo "# open $cb $@"
    baseUrl="https://$(pwd | grep -o 'github.com/[^/]*/[^/]*')"
    open "${baseUrl}/compare/${default_branch}...$cb" $@
  else
    echo "error: branch '$cb' may not be your branch." >&2
    return 1
  fi
}

function gbd() {
  default_branch=$(git_default_branch)
  base=${1:-${default_branch}}
  git checkout -q $base && \
  git for-each-ref refs/heads/ "--format=%(refname:short)" | \
  while read branch; do
    mergeBase=$(git merge-base $base $branch) && \
    [[ $(git cherry $base $(git commit-tree $(git rev-parse "$branch^{tree}") -p $mergeBase -m _)) == "-"* ]] && \
    git branch -D $branch;
  done
}

alias gl=' git log --date=short --pretty=format:"%C(Yellow)%h %C(Cyan)%cd %C(Reset)%s %C(Blue)[%cn]%C(Red)%d" -10'
alias glr='git log --date=short --pretty=format:"%C(Yellow)%h %C(Cyan)%cd %C(Reset)%s %C(Blue)[%cn]%C(Red)%d" --graph'
alias gll='git log --date=short --pretty=format:"%C(Yellow)%h %C(Cyan)%cd %C(Reset)%s %C(Blue)[%cn]%C(Red)%d" --numstat'

function gmain() {
  default_branch=$(git_default_branch)
  git checkout $default_branch
  git pull origin $default_branch
}

alias grc='rm -f /tmp/grc.log && wine /Applications/GRC\ Mobile/GRCmobile.exe >/tmp/grc.log 2>&1 &'

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform
