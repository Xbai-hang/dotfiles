# ~/.config/zsh/03-theme.zsh

# ==============================================================
# 环境隔离：本地 Starship / 服务器 p10k
# ==============================================================
if [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" || -n "$SSH_CONNECTION" ]]; then
  # ---------------- SSH 服务器环境 ----------------
  zinit ice depth=1; zinit light romkatv/powerlevel10k

  # 优先 root 配置
  if [[ -f "$ZDOTDIR/.p10k-root.zsh" ]]; then
      source "$ZDOTDIR/.p10k-root.zsh"
  elif [[ -f "$ZDOTDIR/.p10k.zsh" ]]; then
      source "$ZDOTDIR/.p10k.zsh"
  fi

else
  # ---------------- 本地个人电脑环境 ----------------
  if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
  else
    # 如果本地环境没有安装 starship，退化回 p10k 引擎
    zinit ice depth=1; zinit light romkatv/powerlevel10k
    [[ -f "$ZDOTDIR/.p10k.zsh" ]] && source "$ZDOTDIR/.p10k.zsh"
  fi
fi
