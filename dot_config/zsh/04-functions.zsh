# ~/.config/zsh/04-functions.zsh

# 创建并进入目录
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# 代理切换
proxy() {
  export https_proxy=http://127.0.0.1:7890
  export http_proxy=http://127.0.0.1:7890
  export all_proxy=socks5h://127.0.0.1:7890
}
unproxy() {
  unset https_proxy http_proxy all_proxy
}

# Yazi 终端增强
y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	command rm -f -- "$tmp"
}

# killport: 一键强杀占用指定端口的进程 (例如: killport 3000)
killport() {
  local port=$1
  if [[ -z "$port" ]]; then
    echo "🎯 用法: killport <端口号>"
    return 1
  fi
  local pid
  pid=$(lsof -t -i:"$port")
  if [[ -n "$pid" ]]; then
    echo "🔥 正在强杀占用端口 $port 的进程 (PID: $pid)..."
    echo "$pid" | xargs kill -9
    echo "✨ 端口已释放"
  else
    echo "✅ 端口 $port 目前没有被占用"
  fi
}

# cht: 终端极速速查表 (例如: cht tar, cht rust split, cht git revert)
# 免去打开浏览器搜索的繁琐步骤
cht() {
  if [[ $# -eq 0 ]]; then
    echo "🎯 用法: cht <命令/技术词> [查询的具体语法]"
    echo "示例: cht tar"
    echo "      cht rust split"
    return 1
  fi
  local query
  # 将空格替换为 + 号以适配 URL
  query=$(echo "$*" | tr ' ' '+')
  curl -s "https://cht.sh/$query" | less -R
}

# fzf + ripgrep 组合技
rgf() {
  rg -l "$1" | fzf --preview "rg -n --color=always -C 3 '$1' {}"
}

# Claude Code Profile 切换
ccp() {
  local profile="$1"
  shift
  if [[ -z "$profile" ]]; then
    echo "usage: ccp <profile> [other claude args...]"
    return 1
  fi
  claude --settings "$HOME/.claude/settings.${profile}.json" "$@"
}

web_search() {
  local engine=$1
  shift
  local query
  # 将参数的空格替换为 + 号
  query=$(echo "$*" | tr ' ' '+')

  local url
  case "$engine" in
    google)  url="https://www.google.com/search?q=" ;;
    bing)    url="https://www.bing.com/search?q=" ;;
    github)  url="https://github.com/search?q=" ;;
    youtube) url="https://www.youtube.com/results?search_query=" ;;
    wiki)    url="https://en.wikipedia.org/wiki/Special:Search?search=" ;;
    # 你甚至可以自己加：
    # bilibili) url="https://search.bilibili.com/all?keyword=" ;;
    *)       echo "❌ 未知的搜索引擎: $engine" >&2; return 1 ;;
  esac

  # 调用 macOS 原生 open 命令，直接唤醒默认浏览器
  open "${url}${query}"
}

# 智能跨平台刷新 DNS (合并了方案一的逻辑)
,fdns() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍎 正在清理 macOS DNS 缓存..."
    sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
    echo "✨ 清理完成"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "🐧 正在清理 Linux DNS 缓存..."
    if command -v resolvectl >/dev/null 2>&1; then
      sudo resolvectl flush-caches
    elif command -v systemd-resolve >/dev/null 2>&1; then
      sudo systemd-resolve --flush-caches
    else
      echo "❌ 未检测到系统自带的 DNS 清理工具 (resolvectl/systemd-resolve)" >&2
      return 1
    fi
    echo "✨ 清理完成"
  fi
}

# ==============================================================
# 2. macOS 专属函数 (仅在 Mac 环境下动态注入定义)
# ==============================================================
if [[ "$OSTYPE" == "darwin"* ]]; then
  # cdf: 终端自动 cd 到当前 Finder（访达）最前面窗口所在的目录
  cdf() {
    local target
    target=$(osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)')
    if [[ -n "$target" ]]; then
      cd "$target" || return
      eza -l -g --icons
    else
      echo "❌ 当前没有打开任何 Finder 窗口" >&2
    fi
  }
  # ofd: 用 Finder 打开指定目录（默认当前目录）
  ofd() {
    if [[ $# -eq 0 ]]; then
      open .
    else
      open "$@"
    fi
  }
fi
