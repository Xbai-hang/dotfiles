#!/bin/zsh

emulate -L zsh

root=''
name=''
show_all=0

usage() {
  echo 'Usage: ,checkpid.sh (-p PID | -n NAME) [-a|--all]'
}

while (( $# )); do
  case "$1" in
    -p|--pid)
      (( $# >= 2 )) || { echo 'Missing PID' >&2; exit 2; }
      root=$2
      shift 2
      ;;
    -n|--name)
      (( $# >= 2 )) || { echo 'Missing process name' >&2; exit 2; }
      name=$2
      shift 2
      ;;
    -a|--all)
      show_all=1
      shift
      ;;
    -h|--help)
      usage
      exit
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

[[ -n $root || -n $name ]] || { usage >&2; exit 2; }
[[ -z $root || -z $name ]] || {
  echo 'Use either --pid or --name, not both' >&2
  exit 2
}

typeset -A children parents bins
while read -r pid ppid bin; do
  children[$ppid]+=" $pid"
  parents[$pid]=$ppid
  bins[$pid]=$bin
done < <(ps -ww -axo pid=,ppid=,comm=)

if [[ -z $root ]]; then
  matches=()
  for pid in ${(k)bins}; do
    [[ ${bins[$pid]:l} == *${name:l}* ]] && matches+=("$pid	${bins[$pid]}")
  done

  (( ${#matches} )) || { echo "Process not found: $name" >&2; exit 1; }

  if (( ${#matches} == 1 )); then
    selected=$matches[1]
  elif command -v fzf >/dev/null; then
    selected=$(printf '%s\n' "${matches[@]}" | sort -n | fzf --prompt='Process: ')
  else
    printf '%s\n' "${matches[@]}" >&2
    echo 'Multiple matches; use --pid' >&2
    exit 2
  fi

  [[ -n $selected ]] || exit 1
  root=${selected%%$'\t'*}
fi

[[ $root == <-> && -n ${bins[$root]} ]] || {
  echo "Invalid or missing PID: $root" >&2
  exit 1
}

queue=($root)
processes=()
while (( ${#queue} )); do
  current=$queue[1]
  queue[1]=()
  processes+=($current)
  descendants=( ${=children[$current]} )
  (( ${#descendants} )) && queue+=($descendants)
done

printf '%-7s %-7s %-4s %s\n' PID PPID NET BIN
for pid in $processes; do
  net='-'
  lsof -nP -a -p "$pid" -i >/dev/null 2>&1 && net=YES
  (( show_all )) || [[ $net == YES ]] || continue
  printf '%-7s %-7s %-4s %s\n' \
    "$pid" "${parents[$pid]:--}" "$net" "${bins[$pid]}"
done
