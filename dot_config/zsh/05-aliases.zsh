# ~/.config/zsh/05-aliases.zsh

# 1. 核心替换
alias cls='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# [eza 替代 ls] -------------------------------------------------
if command -v eza >/dev/null 2>&1; then
  unalias ls ll la 2>/dev/null

  function ls { command eza --icons=auto --time-style=long-iso "$@"; }
  function ll { ls -l -g "$@"; }
  function la { ll -a "$@"; }
  function lt { ll --tree --level=2 --git-ignore "$@"; }
  function lat { lt -a "$@"; }

  (( $+functions[compdef] )) && compdef _eza ls ll la lt lat
else
  alias ls='command ls --color=auto'
  alias ll='command ls -l --color=auto'
  alias la='command ls -la --color=auto'
fi

# [bat 替代 cat] ------------------------------------------------
if command -v bat >/dev/null 2>&1; then
  alias cat='bat -p'
fi

# [nvim 替代 vi/vim] --------------------------------------------
if command -v nvim >/dev/null 2>&1; then
  alias vi='nvim'
  alias vim='nvim'
fi

# 2. 工具别名
# ==============================================================
# 别名加载中心：动态扫描并装载 aliases/ 目录下的所有模块
# ==============================================================
if [[ -d "$ZDOTDIR/aliases" ]]; then
  # 遍历 aliases 目录下的所有 .zsh 文件
  # (N) 是 Zsh 专属的 nullglob 标志，防止在空目录时报错
  for file in "$ZDOTDIR/aliases"/*.zsh(N); do
    source "$file"
  done
fi

# web 搜索
if (( $+functions[web_search] )); then
  alias bing='web_search bing'
  alias google='web_search google'
  alias github='web_search github'
  alias youtube='web_search youtube'
  alias wiki='web_search wiki'
fi

if command -v fastfetch >/dev/null 2>&1; then
  alias ff='fastfetch --logo "$XDG_CONFIG_HOME/fastfetch/ikun.txt" --logo-type file --config examples/30'
fi

# 4. 杂项

alias cdtmp='cd $(mktemp -d /tmp/sparyn-XXXXXX)'

alias agyd='agy --dangerously-skip-permissions'

alias ,fzsh='exec zsh'
alias ,pnet='$XDG_CONFIG_HOME/scripts/checkpid.sh'
alias ,ezconf='$EDITOR $ZDOTDIR/local.zsh'
