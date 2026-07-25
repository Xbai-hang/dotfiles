# ~/.config/zsh/02-plugins.zsh

# 1. 路径预备
if [[ -d "$ZDOTDIR/completions" ]]; then
  fpath=("$ZDOTDIR/completions" $fpath)
fi

typeset -a brew_completions
brew_completions=(
  "${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh/site-functions"
  "/usr/local/share/zsh/site-functions"
  "/home/linuxbrew/.linuxbrew/share/zsh/site-functions"
)

for dir in $brew_completions; do
  if [[ -d "$dir" ]]; then
    fpath=("$dir" $fpath)
  fi
done
# 去重
typeset -U fpath FPATH

# 2. 加载 Zinit 运行库
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ -f "${ZINIT_HOME}/zinit.zsh" ]]; then
  source "${ZINIT_HOME}/zinit.zsh"
fi

# 3. OMZ 组件白嫖
# hint: double-type [ESC] for sudo
zinit snippet OMZP::sudo
# hint: z command
zinit snippet OMZP::extract
# hint: OMZP::git 是大量 Git alias 集合，保留供肌肉记忆使用
# zinit snippet OMZP::git
if [[ "$OSTYPE" == "darwin"* ]]; then
  # zinit snippet OMZP::macos
fi

# 4. 启用路径补全
autoload -Uz compinit
compinit

# 让 Zinit 重新播放并注入所有通过 Zinit 安装的插件补全
zinit cdreplay -q

# 5. 神级插件
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
# ⚠️ 注意：syntax-highlighting 必须在绝大多数配置之后加载
zinit light zsh-users/zsh-syntax-highlighting

# 6. 外部工具初始化
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v fnm >/dev/null 2>&1 && eval "$(fnm env --use-on-cd --shell zsh)"
command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)
