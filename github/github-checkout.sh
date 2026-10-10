#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CSV_PATH="${1:-"$SCRIPT_DIR/../windows_dev_setup.csv"}"

DEFAULT_LOCAL_DIR="~"
DEFAULT_PROFILE="https://github.com/Akash-Mittal"

# Reads a value from the CSV (columns: worksheet,config,value).
# Usage: get_config <worksheet> <config> <default>
get_config() {
  local worksheet="$1" config="$2" default="$3" value=""

  if [[ -f "$CSV_PATH" ]]; then
    value="$(awk -F',' -v ws="$worksheet" -v cfg="$config" '
      function clean(s) { gsub(/\r/, "", s); gsub(/^[ \t"]+|[ \t"]+$/, "", s); return s }
      NR == 1 { next }
      tolower(clean($1)) == tolower(ws) && tolower(clean($2)) == tolower(cfg) { print clean($3); exit }
    ' "$CSV_PATH")"
  else
    echo "[WARN] windows_dev_setup.csv not found at $CSV_PATH. Using defaults." >&2
  fi

  echo "${value:-$default}"
}

expand_home() {
  local path="$1" home="${USERPROFILE:-$HOME}"
  if command -v cygpath >/dev/null 2>&1; then
    home="$(cygpath -u "$home")"
  fi
  case "$path" in
    "~") echo "$home" ;;
    "~/"*) echo "$home/${path#\~/}" ;;
    *) echo "$path" ;;
  esac
}

# Prints "name url" per repo of the given GitHub user.
list_repos() {
  local user="$1"

  if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
    gh repo list "$user" --limit 1000 --json name,url --jq '.[] | "\(.name) \(.url).git"'
    return
  fi

  if ! command -v jq >/dev/null 2>&1; then
    echo "[ERROR] jq not found (needed when gh is not logged in). Install it: scoop install jq" >&2
    exit 1
  fi

  local page=1 response count
  while :; do
    response="$(curl -fsSL ${GITHUB_TOKEN:+-H "Authorization: Bearer $GITHUB_TOKEN"} \
      "https://api.github.com/users/$user/repos?per_page=100&page=$page")"
    count="$(jq 'length' <<< "$response" | tr -d '\r')"
    [[ "$count" -eq 0 ]] && break
    jq -r '.[] | "\(.name) \(.clone_url)"' <<< "$response"
    page=$((page + 1))
  done
}

local_dir="$(expand_home "$(get_config "github_config" "config_localgithub_dir" "$DEFAULT_LOCAL_DIR")")"
profile="$(get_config "github_config" "config_userprofile_checkout_dir" "$DEFAULT_PROFILE")"

profile="${profile%/}"
github_user="${profile##*/}"

if [[ -z "$github_user" ]]; then
  echo "[ERROR] Could not read a GitHub user from: $profile" >&2
  exit 1
fi

mkdir -p "$local_dir"

echo "[DEBUG] GitHub user: $github_user"
echo "[DEBUG] Checkout dir: $local_dir"

# Windows builds of jq/gh emit CRLF; a trailing CR breaks the clone URL.
repos="$(list_repos "$github_user" | tr -d '\r')"
if [[ -z "$repos" ]]; then
  echo "[ERROR] No repos found for $github_user" >&2
  exit 1
fi

any_failed=0

while read -r name url <&3; do
  [[ -z "$name" ]] && continue
  target="$local_dir/$name"

  echo "========================================"
  if [[ -d "$target" ]]; then
    echo "[DEBUG] $name | Already exists, skipping: $target"
    continue
  fi

  echo "[DEBUG] $name | git clone $url"
  if ! git clone "$url" "$target"; then
    echo "[ERROR] $name | Clone FAILED" >&2
    any_failed=1
  fi
done 3<<< "$repos"

echo "========================================"
if [[ "$any_failed" -ne 0 ]]; then
  echo "[ERROR] One or more repositories failed to clone." >&2
  exit 1
fi

echo "[DEBUG] All repositories checked out to $local_dir."
