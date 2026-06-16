#!/usr/bin/env bash
set -euo pipefail

OH_MY_ZSH="$HOME/.oh-my-zsh"
ZSH_CUSTOM="${ZSH_CUSTOM:-$OH_MY_ZSH/custom}"

THEME_DIR="$ZSH_CUSTOM/themes/powerlevel10k"
PLUGIN_DIR="$ZSH_CUSTOM/plugins"

# Clone or update a git repository.
clone_or_update() {
  local repo="$1"
  local dir="$2"

  if [[ -d "$dir/.git" ]]; then
    git -C "$dir" pull --ff-only
  elif [[ ! -e "$dir" ]]; then
    git clone --depth=1 "$repo" "$dir"
    B
  else
    echo "skip: $dir exists but is not a git repository"
  fi
}

# Install Oh My Zsh.
if [[ ! -d "$OH_MY_ZSH/.git" ]]; then
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$OH_MY_ZSH"
fi

mkdir -p "$ZSH_CUSTOM/themes" "$PLUGIN_DIR"

# Install Powerlevel10k.
clone_or_update \
  https://github.com/romkatv/powerlevel10k.git \
  "$THEME_DIR"

# Install third-party plugins.
clone_or_update \
  https://github.com/zsh-users/zsh-autosuggestions.git \
  "$PLUGIN_DIR/zsh-autosuggestions"

clone_or_update \
  https://github.com/zsh-users/zsh-syntax-highlighting.git \
  "$PLUGIN_DIR/zsh-syntax-highlighting"

clone_or_update \
  https://github.com/zsh-users/zsh-history-substring-search.git \
  "$PLUGIN_DIR/zsh-history-substring-search"
