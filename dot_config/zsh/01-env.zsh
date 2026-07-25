# ~/.config/zsh/01-env.zsh

# 1. XDG 规范
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# 2. Homebrew 嗅探
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# 3. 核心路径组装 (全局跨平台路径)
# Go & Rust 环境变量 (统一收纳进 XDG_DATA_HOME)
export GOPATH="$XDG_DATA_HOME/go"
export GOBIN="$HOME/.local/bin"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

path=(
  "$HOME/.local/bin"
  "$CARGO_HOME/bin"
  "/opt/homebrew/bin"    # Mac Apple Silicon 必备
  "/usr/local/bin"       # Mac Intel / Linux 常用
  $path
)
typeset -U path PATH

# 4. 系统环境
export LANG="en_US.UTF-8"
export TZ='Asia/Shanghai'
export ARCHFLAGS="-arch $(uname -m)"
export HOMEBREW_NO_ENV_HINTS=1

# Go Proxy
export GOPROXY="https://goproxy.cn,direct"
export GOSUMDB="sum.golang.google.cn"

# 5. 降级编辑器
# nvim 存在且不在 SSH 环境下，才使用 nvim，否则一层层降级。
if command -v nvim >/dev/null 2>&1 && [[ -z "$SSH_CONNECTION" ]]; then
  export EDITOR="nvim"
elif command -v vim >/dev/null 2>&1; then
  export EDITOR="vim"
else
  export EDITOR="vi"
fi
export VISUAL="$EDITOR"

# 6. 现代 CLI 强化

# [搜索增强: FZF]
if command -v fd >/dev/null 2>&1; then
  # 让 FZF 底层调用 fd 进行高性能文件查找，并剔除 .git 目录
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
  export FZF_CTRL_T_COMMAND='fd --type f --hidden --exclude .git'
fi
# [终端显示: PAGER & BAT]
# 配置默认分页器支持色彩输出和鼠标滚轮
export PAGER="less -FRX"
# 预设 BAT 主题
export BAT_THEME="TwoDark"
# 配置 JQ 的 JSON 高亮颜色
export JQ_COLORS='0;90:0;31:0;36:0;34:0;32:0;37:0;37:1;36'

# [终端历史: ZSH History]
# 将历史记录写入 XDG 目录，防止主目录被污染
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export HISTSIZE=100000
export SAVEHIST=100000
# 确保历史记录目录存在
[[ ! -d "$(dirname "$HISTFILE")" ]] && mkdir -p "$(dirname "$HISTFILE")"

# 历史记录行为控制 (找回实时互通)
setopt autocd                 # 无需 cd 输入目录名直接切换
setopt SHARE_HISTORY          # 实时共享历史记录 (所有窗口命令实时同步，解决你的痛点)
setopt INC_APPEND_HISTORY     # 执行命令时立即写入文件，而不是等到窗口关闭才写
setopt HIST_IGNORE_ALL_DUPS   # 自动清理历史记录中所有的重复命令，保持历史文件干净
setopt HIST_REDUCE_BLANKS     # 自动清理命令中多余的空格，规范化历史记录
# ==============================================================
# 1. 还原 OMZ 补全系统 (Tab 键丝滑菜单与模糊匹配)
# ==============================================================
# 开启 Tab 键菜单选择，允许你使用【方向键】在候选列表中上下左右移动选择
zstyle ':completion:*' menu select

# 大小写与模糊自动忽略补全 (极其重要！敲 cd downloads 自动匹配 Downloads，敲部分字符自动补全)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# 补全列表自动带上和 ls 一样的颜色高亮，方便人眼识别文件类型
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# 补全时如果敲错了一两个字母，自动进行近似值猜测补全
zstyle ':completion:*' completer _expand _complete _correct _approximate

# ==============================================================
# 2. 还原 OMZ 细节行为 (静音与交互优化)
# ==============================================================
setopt NO_BEEP                # 禁用敲错字母或补全失败时，Mac 扬声器发出恶心的“嘟嘟”警报声
setopt INTERACTIVE_COMMENTS   # 允许你在命令行里直接粘贴带 # 号的注释代码，而不会报错
setopt AUTO_RESUME            # 允许直接输入被挂起的任务名来恢复它 (比如你用 Ctrl+Z 挂起了 vim，直接输入 vim 就能恢复)
setopt LIST_PACKED            # 紧凑排列补全候选列表，节省屏幕空间
setopt CORRECT                # 开启拼写纠错 (如 gti -> git)
setopt RM_STAR_WAIT           # rm * 危险操作强制等待 10 秒确认
setopt EXTENDED_GLOB          # 启用高阶通配符匹配 (如 ^, #, ~)

# 目录栈自动记录 (允许使用 popd 快速回退路径)
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# 彩色 Man Pages 渲染 (还原 OMZ 经典的彩色文档阅读体验)
export LESS_TERMCAP_mb=$'\E[1;31m'      # 闪烁
export LESS_TERMCAP_md=$'\E[1;36m'      # 粗体 (青色)
export LESS_TERMCAP_me=$'\E[0m'         # 属性重置
export LESS_TERMCAP_se=$'\E[0m'         # 突出结束
export LESS_TERMCAP_so=$'\E[01;33m'     # 突出开始 (黄色)
export LESS_TERMCAP_ue=$'\E[0m'         # 下划线结束
export LESS_TERMCAP_us=$'\E[1;4;32m'    # 下划线开始 (绿色)
