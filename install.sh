#!/usr/bin/env bash
# ============================================================
# dotfiles インストールスクリプト
# Mac (zsh) / WSL Ubuntu 両対応
# ============================================================
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IS_MAC=false
IS_WSL=false

[[ "$(uname)" == "Darwin" ]] && IS_MAC=true
[[ -f /proc/version ]] && grep -qi microsoft /proc/version && IS_WSL=true

# カラー出力
info()    { echo -e "\033[0;34m[INFO]\033[0m  $*"; }
success() { echo -e "\033[0;32m[OK]\033[0m    $*"; }
warn()    { echo -e "\033[0;33m[WARN]\033[0m  $*"; }
error()   { echo -e "\033[0;31m[ERROR]\033[0m $*"; exit 1; }

symlink() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    warn "バックアップ: $dst -> ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi
  ln -sfn "$src" "$dst"
  success "リンク: $dst -> $src"
}

# ============================================================
# Homebrew のインストール (Mac / WSL)
# ============================================================
install_homebrew() {
  if command -v brew &>/dev/null; then
    info "Homebrew は既にインストール済み"
    return
  fi
  info "Homebrew をインストール中..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if $IS_WSL; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
}

# ============================================================
# CLI ツールのインストール
# ============================================================
install_tools() {
  info "CLIツールをインストール中..."
  local tools=(
    zsh
    starship
    zoxide
    fzf
    fd
    ripgrep
    bat
    eza
    atuin
    git
    neovim
  )
  brew install "${tools[@]}"
  success "CLIツールのインストール完了"
}

# ============================================================
# フォントのインストール
# ============================================================
install_fonts() {
  if $IS_MAC; then
    info "JetBrains Mono Nerd Font をインストール中..."
    brew install --cask font-jetbrains-mono-nerd-font
    success "フォントインストール完了"
  else
    warn "WSL/Linux の場合、フォントはWindowsホスト側にインストールが必要です"
    warn "https://github.com/ryanoasis/nerd-fonts/releases からJetBrainsMonoNerdFont をダウンロードしてください"
  fi
}

# ============================================================
# 旧設定のクリーンアップ
# ============================================================
cleanup_old() {
  info "旧設定をクリーンアップ中..."

  # prezto
  if [[ -d ~/.zprezto ]]; then
    warn "~/.zprezto を削除します"
    rm -rf ~/.zprezto
    success "prezto 削除完了"
  fi

  # YADR
  if [[ -d ~/.yadr ]]; then
    warn "~/.yadr を削除します"
    rm -rf ~/.yadr
    success "YADR 削除完了"
  fi
}

# ============================================================
# シンボリックリンクの作成
# ============================================================
create_symlinks() {
  info "シンボリックリンクを作成中..."

  # zsh
  symlink "${DOTFILES_DIR}/zsh/zshrc"          ~/.zshrc
  symlink "${DOTFILES_DIR}/zsh/exports.zsh"    ~/.config/zsh/exports.zsh
  symlink "${DOTFILES_DIR}/zsh/aliases.zsh"    ~/.config/zsh/aliases.zsh
  symlink "${DOTFILES_DIR}/zsh/functions.zsh"  ~/.config/zsh/functions.zsh

  # Starship
  symlink "${DOTFILES_DIR}/starship/starship.toml" ~/.config/starship.toml

  # WezTerm (Mac / Windows両対応)
  symlink "${DOTFILES_DIR}/wezterm/wezterm.lua" ~/.config/wezterm/wezterm.lua
}

# ============================================================
# デフォルトシェルを zsh に変更
# ============================================================
set_default_shell() {
  if [[ "$SHELL" == *"zsh"* ]]; then
    info "デフォルトシェルは既にzsh"
    return
  fi
  local zsh_path
  zsh_path=$(command -v zsh)
  info "デフォルトシェルを zsh に変更: $zsh_path"
  if ! grep -q "$zsh_path" /etc/shells; then
    echo "$zsh_path" | sudo tee -a /etc/shells
  fi
  chsh -s "$zsh_path"
  success "デフォルトシェル変更完了 (再ログイン後に反映)"
}

# ============================================================
# メイン
# ============================================================
main() {
  echo ""
  echo "========================================"
  echo "  dotfiles インストール開始"
  echo "========================================"
  echo ""

  install_homebrew
  cleanup_old
  install_tools
  install_fonts
  create_symlinks
  set_default_shell

  echo ""
  echo "========================================"
  success "インストール完了!"
  echo "========================================"
  echo ""
  echo "次のステップ:"
  echo "  1. ターミナルを再起動 (または: source ~/.zshrc)"
  echo "  2. WezTerm でフォント 'JetBrainsMono Nerd Font' を確認"
  if ! $IS_MAC; then
    echo "  3. Windows側でフォントをインストールしてWezTermのフォント設定を確認"
  fi
  echo ""
}

main "$@"
