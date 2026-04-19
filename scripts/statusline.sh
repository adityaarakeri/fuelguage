#!/usr/bin/env bash
# fuelguage: folder, git branch, color-coded progress bars
# Works on macOS, Linux, WSL2

input=$(cat)

# --- Style ---
BOLD='\033[1m'; DIM='\033[2m'; RESET='\033[0m'
CYAN='\033[36m'; MAGENTA='\033[35m'

# --- Parse JSON (jq) ---
if ! command -v jq >/dev/null 2>&1; then
  printf 'fuelguage: jq not found. Install jq (brew/apt/winget) and reload Claude Code.'
  exit 0
fi

cwd=$(printf '%s' "$input"      | jq -r '.workspace.current_dir // .cwd // "."')
ctx=$(printf '%s' "$input"      | jq -r '(.context_window.used_percentage // 0) | floor')
fivehr=$(printf '%s' "$input"   | jq -r '(.rate_limits.five_hour.used_percentage // 0) | floor')
sevenday=$(printf '%s' "$input" | jq -r '(.rate_limits.seven_day.used_percentage // 0) | floor')
model=$(printf '%s' "$input"    | jq -r 'if (.model | type) == "object" then (.model.display_name // .model.id // "") else (.model // "") end')

# Shorten fallback model ids: claude-sonnet-4-6 → sonnet-4.6
if [[ -n "$model" && "$model" == claude-* ]]; then
  model="${model#claude-}"
  model=$(printf '%s' "$model" | sed 's/-\([0-9]*\)$/.\1/')
fi

# --- Folder (basename, ~ for home) ---
folder="${cwd/#$HOME/~}"
folder="${folder##*/}"
[ -z "$folder" ] && folder="~"

# --- Git branch (fast, silent) ---
branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null \
      || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)

# --- Color-coded progress bar ---
make_bar() {
  local pct=$1 label=$2 width=10
  local filled=$((pct * width / 100))
  [ "$filled" -gt "$width" ] && filled=$width
  local empty=$((width - filled))

  local color
  if   [ "$pct" -ge 90 ]; then color='\033[38;5;203m'   # red
  elif [ "$pct" -ge 70 ]; then color='\033[38;5;221m'   # yellow
  else                         color='\033[38;5;114m'   # green
  fi

  local bar="" i
  i=0; while [ "$i" -lt "$filled" ]; do bar="${bar}█"; i=$((i+1)); done
  i=0; while [ "$i" -lt "$empty"  ]; do bar="${bar}░"; i=$((i+1)); done

  printf '%b%s %b%s%b %3d%%%b' "$DIM" "$label" "$color" "$bar" "$RESET" "$pct" "$RESET"
}

YELLOW='\033[33m'
SEP="${DIM} │ ${RESET}"
out="${BOLD}${MAGENTA}${folder}${RESET}"
[ -n "$branch" ] && out+="${SEP}${CYAN}(${branch})${RESET}"
[ -n "$model"  ] && out+="${SEP}${DIM}${YELLOW}${model}${RESET}"
out+="${SEP}$(make_bar "$ctx" "ctx")"
out+="${SEP}$(make_bar "$fivehr" "5h")"
out+="${SEP}$(make_bar "$sevenday" "7d")"

printf '%b' "$out"
