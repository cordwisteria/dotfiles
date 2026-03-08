# ============================================================
# fzf を使ったユーティリティ
# ============================================================

# fzf でブランチを選んでcheckout
gfco() {
  local branch
  branch=$(git branch -a | fzf --prompt="Branch: " | sed 's/remotes\/origin\///' | tr -d ' ')
  [[ -n "$branch" ]] && git checkout "$branch"
}

# fzf でファイルを選んで開く
fe() {
  local file
  file=$(fzf --prompt="File: " --preview="bat --color=always {}")
  [[ -n "$file" ]] && ${EDITOR:-nvim} "$file"
}

# ディレクトリを作ってそこに移動
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# プロセスをfzfで選んでkill
fkill() {
  local pid
  pid=$(ps aux | fzf | awk '{print $2}')
  [[ -n "$pid" ]] && kill -${1:-9} "$pid"
}

# パスを通す (重複チェック付き)
path_append() {
  if [[ ":$PATH:" != *":$1:"* ]]; then
    export PATH="$PATH:$1"
  fi
}

# コマンドの存在確認
has() {
  command -v "$1" &>/dev/null
}
