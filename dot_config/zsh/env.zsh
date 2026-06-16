# Environment variables shared across Unix-like systems

# XDG base directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Editor
# Use vim over SSH for compatibility; use nvim locally
if [[ -n "$SSH_CONNECTION" ]]; then
  export EDITOR="vim"
else
  export EDITOR="nvim"
fi

export VISUAL="$EDITOR"

export ARCHFLAGS="-arch $(uname -m)"

