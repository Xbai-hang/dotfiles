#!/bin/bash
# ==============================================================
# Chezmoi 前置依赖自动装机脚本 (优先级: Brew -> Cargo -> OS)
# ==============================================================

set -euo pipefail

# 确保本地执行目录存在
mkdir -p "$HOME/.local/bin"

# 核心装机函数（执行局部优先级下沉算法）
install_tool() {
  local tool=$1       # 最终命令名 (如 rg)
  local brew_name=$2   # Homebrew 包名
  local cargo_name=$3  # Cargo crate 名 ("none" 代表不支持 cargo)
  local apt_name=$4    # Debian/Ubuntu 包名
  local dnf_name=$5    # RHEL/CentOS 包名
  local scoop_name=$6  # Windows Scoop 包名

  # 如果命令已经存在，直接跳过
  if command -v "$tool" >/dev/null 2>&1; then
    echo "✅ $tool 已经存在，跳过安装"
    return 0
  fi

  echo "⏳ 开始为系统寻找并安装 $tool..."

  # 【优先级 1】: Homebrew (macOS 主力机首选)
  if command -v brew >/dev/null 2>&1; then
    echo "  -> 发现 Homebrew，正在安装..."
    brew install "$brew_name"
    return 0
  fi

  # 【优先级 2】: Cargo 源码编译 (Linux/Windows 跨平台首选)
  if command -v cargo >/dev/null 2>&1 && [ "$cargo_name" != "none" ]; then
    echo "  -> 发现 Cargo，开始通过源码构建 $tool (需等待编译)..."
    cargo install "$cargo_name" --locked
    return 0
  fi

  # 【优先级 3】: Debian/Ubuntu apt
  if command -v apt-get >/dev/null 2>&1; then
    echo "  -> 发现 apt，正在通过系统源安装..."
    sudo apt-get update -y && sudo apt-get install -y "$apt_name"
    return 0
  fi

  # 【优先级 4】: RHEL/CentOS dnf
  if command -v dnf >/dev/null 2>&1; then
    echo "  -> 发现 dnf，正在通过系统源安装..."
    sudo dnf install -y "$dnf_name"
    return 0
  fi

  # 【优先级 5】: Windows Scoop (WSL/Git Bash 兼容)
  if command -v scoop >/dev/null 2>&1; then
    echo "  -> 发现 Scoop，正在安装..."
    scoop install "$scoop_name"
    return 0
  fi

  echo "❌ 警告: 找不到适合安装 $tool 的包管理器，请手动安装！"
  return 1
}

# 执行装机队列 (指令 | Brew名 | Cargo名 | Apt名 | Dnf名 | Scoop名)
install_tool "zoxide"    "zoxide"    "zoxide"      "zoxide"    "zoxide"    "zoxide"
install_tool "eza"       "eza"       "eza"         "eza"       "eza"       "eza"
install_tool "bat"       "bat"       "bat"         "bat"       "bat"       "bat"
install_tool "fd"        "fd"        "fd-find"     "fd-find"   "fd-find"   "fd-find"
install_tool "rg"        "ripgrep"   "ripgrep"     "ripgrep"   "ripgrep"   "ripgrep"
install_tool "delta"     "git-delta" "git-delta"   "git-delta" "git-delta" "delta"

# 以下是非 Rust 编写的工具，将自动避开 Cargo，安全沉降到系统包管理器安装：
install_tool "fzf"       "fzf"       "none"        "fzf"       "fzf"       "fzf"
install_tool "fastfetch" "fastfetch" "none"        "fastfetch" "fastfetch" "fastfetch"
install_tool "lazygit"   "lazygit"   "none"        "git"       "git"       "lazygit"

# 4. 修复 Debian/Ubuntu 专有的 bat/fd 命令命名偏差
if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
  echo "🔗 创建 fd 软链接..."
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi

if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
  echo "🔗 创建 bat 软链接..."
  ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
fi

echo "🎉 跨平台环境前置依赖装载校验完毕！"
