# ============================================================
# PATH
# ============================================================
# Homebrew (Mac)
if [[ -d /opt/homebrew ]]; then
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
elif [[ -d /home/linuxbrew/.linuxbrew ]]; then
  export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
fi

export PATH="$HOME/.local/bin:$PATH"

# 重複除去
typeset -U PATH

# ============================================================
# 基本設定
# ============================================================
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
export LESS="-R --mouse"

# ============================================================
# ツール設定
# ============================================================
# fzf: Solarized Dark に合わせた配色
export FZF_DEFAULT_OPTS="
  --height 40%
  --layout=reverse
  --border=rounded
  --color=bg+:#073642,bg:#002b36,spinner:#2aa198,hl:#268bd2
  --color=fg:#839496,header:#586e75,info:#b58900,pointer:#2aa198
  --color=marker:#2aa198,fg+:#93a1a1,prompt:#b58900,hl+:#268bd2
"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# bat: Solarized Dark
export BAT_THEME="Solarized (dark)"

# zoxide
export _ZO_ECHO=1  # cdしたあとにパスを表示

# ============================================================
# 秘密情報 (gitに入れない)
# ============================================================
[[ -f ~/.secrets ]] && source ~/.secrets
