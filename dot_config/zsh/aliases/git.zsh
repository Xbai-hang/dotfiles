# ~/.config/zsh/aliases/git.zsh

command -v git >/dev/null 2>&1 || return 0

# Git
alias g='git'

## [基础与状态]
alias gs='git status'
alias ga='git add'

## [提交]
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend' # 追加提交（修改上一次 commit 且不产生新纪录）

## [推送与拉取]
alias gp='git push'
alias gpf='git push --force-with-lease' # 强制推送（比 -f 更安全）
alias gl='git pull'
alias glr='git pull --rebase' # 变基拉取（拉取时自动 rebase）
alias gf='git fetch'

## [分支与切换]
alias gb='git branch'
alias gba='git branch -a'
alias gcb='git checkout -b'
if command -v fzf >/dev/null 2>&1; then
  alias gco='git branch --format="%(refname:short)" | fzf | xargs git checkout'
fi

## [比对与撤销]
alias gd='git diff'
alias gds='git diff --staged' # 对比暂存区（对比 git commit 前后修改）
alias grs='git restore' # 撤销工作区修改
alias grss='git restore --staged' # 讲已 add 的文件移出暂存区（==git reset HEAD）

## [历史树]
alias glog='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
