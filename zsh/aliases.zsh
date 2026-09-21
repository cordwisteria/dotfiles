# ============================================================
# ファイル操作 (modern CLI tools)
# ============================================================
if command -v eza &>/dev/null; then
  alias ls='eza --icons'
  alias ll='eza -alh --icons --git'
  alias la='eza -a --icons'
  alias lt='eza --tree --icons -L 2'
  alias llt='eza --tree --icons -L 3 -l'
else
  alias ll='ls -alGh'
  alias la='ls -A'
fi

if command -v bat &>/dev/null; then
  alias cat='bat --style=plain --paging=never'
fi

if command -v fd &>/dev/null; then
  alias find='fd'
fi

# ============================================================
# ナビゲーション
# ============================================================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cdb='cd -'
alias cls='clear && ls'
alias cl='clear'
alias :q='exit'

# ============================================================
# Git
# ============================================================
alias gs='git status'
alias ga='git add -A'
alias gap='git add -p'
alias gc='git commit'
alias gcm='git commit -m'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
alias gdc='git diff --cached'
alias gds='git diff --staged'
alias gpl='git pull'
alias gplr='git pull --rebase'
alias gps='git push'
alias gpsh='git push -u origin $(git rev-parse --abbrev-ref HEAD)'
alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gm='git merge'
alias gr='git rebase'
alias gst='git stash'
alias gsp='git stash pop'
alias gl='git log --oneline --graph --decorate'
alias glg='git log --oneline --graph --decorate --all'
alias gnb='git checkout -b'
alias gdmb='git branch --merged | grep -v "\*" | xargs -n 1 git branch -d'
alias grsh='git reset --hard'
alias gclndf='git clean -df'

# ============================================================
# システム
# ============================================================
alias df='df -h'
alias du='du -h -d 2'
alias psa='ps aux'
alias psg='ps aux | grep'
alias k9='kill -9'
alias ka9='killall -9'
alias less='less -r'
alias tf='tail -f'

# ============================================================
# Homebrew
# ============================================================
alias brewu='brew update && brew upgrade && brew cleanup && brew doctor'

# ============================================================
# 設定編集ショートカット
# ============================================================
alias zrc='$EDITOR ~/.zshrc'
alias zrel='source ~/.zshrc'
alias ae='$EDITOR ~/.config/zsh/aliases.zsh'
alias wrc='$EDITOR ~/.config/wezterm/wezterm.lua'

# ============================================================
# Finder (Mac only)
# ============================================================
if [[ "$(uname)" == "Darwin" ]]; then
  alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
  alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
fi
