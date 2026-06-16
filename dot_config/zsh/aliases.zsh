# ~/.config/zsh/aliases.zsh
# Shared aliases. Keep machine-specific aliases in local.zsh.

# Editor.
alias vi='nvim'
alias vim='nvim'

# Common.
alias cls='clear'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# Chezmoi.
alias cz='chezmoi'
alias cza='chezmoi apply'
alias cze='chezmoi edit'
alias czd='chezmoi diff'
alias czs='chezmoi status'
alias czu='chezmoi update'

# Git.
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

# Docker.
alias d='docker'
alias dc='docker compose'
alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias dlog='docker logs'
alias dex='docker exec -it'

# Fastfetch.
alias ff='fastfetch --logo "$HOME/.config/fastfetch/ikun.txt" --logo-type file --config examples/30'

