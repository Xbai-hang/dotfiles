# ~/.config/zsh/functions.zsh
# Shared shell functions.

# Create a directory and cd into it.
mkcd() {
  mkdir -p "$1" && cd "$1"
}

proxy() {
  export https_proxy=http://127.0.0.1:7890
  export http_proxy=http://127.0.0.1:7890
  export all_proxy=socks5://127.0.0.1:7890
}

unproxy() {
  unset https_proxy http_proxy all_proxy
}

