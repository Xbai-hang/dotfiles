# PATH setup. Put earlier entries first

# Homebrew.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# User binaries.
path=(
  "$HOME/.local/bin"
  $path
)

# Remove duplicate PATH entries.
typeset -U path PATH

# Refresh command hash so newly installed binaries can be found.
hash -r 2>/dev/null || true
