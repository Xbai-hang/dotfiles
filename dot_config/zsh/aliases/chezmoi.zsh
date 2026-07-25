# ~/.config/zsh/aliases/chezmoi.zsh

command -v chezmoi >/dev/null 2>&1 || return 0

alias cz='chezmoi'
alias cza='chezmoi apply'
alias cze='chezmoi edit'
alias czd='chezmoi diff'
alias czs='chezmoi status'
alias czu='chezmoi update'
