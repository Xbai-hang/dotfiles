#!/bin/bash

# 1. 下载 Zinit 引擎本体
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  echo "🚀 正在安装 Zinit 引擎..."
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# 2. 触发后台静默预热 (核心魔法)
echo "📦 正在预下载所有 Zinit 插件与 Snippets..."
# 启动一个用完即毁的 zsh 进程，强行加载 03-plugins.zsh。
# 这会骗过 Zinit，让它在后台默默把所有缺少的插件全部下载到本地缓存中。
zsh -c "source $HOME/.config/zsh/.zshrc"

echo "✅ 环境预热完毕！第一次打开终端将享受毫秒级启动。"
