#!/usr/bin/env bash
set -euo pipefail

# Usage: start-chrome.sh [profile ...]
# Profiles default to chrome_config/startup_profiles, or every configured profile.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CSV_PATH="${CSV_PATH:-"$SCRIPT_DIR/../windows_dev_setup.csv"}"
WORKSHEET="chrome_config"

USER_HOME="${USERPROFILE:-$HOME}"
LOCAL_APP_DATA="${LOCALAPPDATA:-}"
if command -v cygpath >/dev/null 2>&1; then
  USER_HOME="$(cygpath -u "$USER_HOME")"
  [[ -n "$LOCAL_APP_DATA" ]] && LOCAL_APP_DATA="$(cygpath -u "$LOCAL_APP_DATA")"
fi

if [[ ! -f "$CSV_PATH" ]]; then
  echo "[ERROR] windows_dev_setup.csv not found: $CSV_PATH" >&2
  exit 1
fi

# Prints every value of <config> in the chrome_config worksheet, in file order.
# Usage: get_configs <config>
get_configs() {
  awk -F',' -v ws="$WORKSHEET" -v cfg="$1" '
    function clean(s) { gsub(/\r/, "", s); gsub(/^[ \t"]+|[ \t"]+$/, "", s); return s }
    NR == 1 { next }
    tolower(clean($1)) == tolower(ws) && tolower(clean($2)) == tolower(cfg) {
      value = $3; for (i = 4; i <= NF; i++) value = value "," $i
      value = clean(value)
      if (value != "") print value
    }
  ' "$CSV_PATH"
}

# Usage: get_config <config> <default>
get_config() {
  local value
  value="$(get_configs "$1" | head -n 1)"
  echo "${value:-$2}"
}

# Profile names from "<profile>.profile_directory" rows, in file order.
list_profiles() {
  awk -F',' -v ws="$WORKSHEET" '
    function clean(s) { gsub(/\r/, "", s); gsub(/^[ \t"]+|[ \t"]+$/, "", s); return s }
    NR == 1 { next }
    tolower(clean($1)) == tolower(ws) {
      cfg = tolower(clean($2))
      if (cfg ~ /\.profile_directory$/) { sub(/\.profile_directory$/, "", cfg); if (!seen[cfg]++) print cfg }
    }
  ' "$CSV_PATH"
}

find_chrome() {
  local configured="$1" candidate
  if [[ -n "$configured" ]]; then
    command -v cygpath >/dev/null 2>&1 && configured="$(cygpath -u "$configured")"
    [[ -f "$configured" ]] && { echo "$configured"; return; }
    command -v "$configured" 2>/dev/null && return
  fi
  for candidate in \
    "$USER_HOME/scoop/apps/googlechrome/current/chrome.exe" \
    "/c/Program Files/Google/Chrome/Application/chrome.exe" \
    "/c/Program Files (x86)/Google/Chrome/Application/chrome.exe" \
    "$LOCAL_APP_DATA/Google/Chrome/Application/chrome.exe"; do
    [[ -f "$candidate" ]] && { echo "$candidate"; return; }
  done
  command -v chrome.exe 2>/dev/null || command -v google-chrome 2>/dev/null || return 1
}

if ! chrome_exe="$(find_chrome "$(get_config "chrome_exe" "")")"; then
  echo "[ERROR] Chrome not found. Set chrome_config,chrome_exe in $CSV_PATH" >&2
  exit 1
fi

delay_ms="$(get_config "delay_ms" "150")"
delay_seconds="$(awk -v ms="$delay_ms" 'BEGIN { printf "%.3f", ms / 1000 }')"

mapfile -t available < <(list_profiles)
if [[ "${#available[@]}" -eq 0 ]]; then
  echo "[ERROR] No profiles found in worksheet $WORKSHEET (expected <profile>.profile_directory rows)" >&2
  exit 1
fi

profiles=("$@")
if [[ "${#profiles[@]}" -eq 0 ]]; then
  read -r -a profiles <<< "$(get_config "startup_profiles" "")"
fi
if [[ "${#profiles[@]}" -eq 0 ]]; then
  profiles=("${available[@]}")
fi

any_failed=0

for profile in "${profiles[@]}"; do
  key="${profile,,}"

  if [[ " ${available[*]} " != *" $key "* ]]; then
    echo "[ERROR] Profile '$profile' not found. Available: ${available[*]}" >&2
    any_failed=1
    continue
  fi

  profile_dir="$(get_config "$key.profile_directory" "")"
  mapfile -t urls < <(get_configs "$key.url")

  if [[ "${#urls[@]}" -eq 0 ]]; then
    echo "[ERROR] No URLs configured for profile '$profile' ($key.url rows)" >&2
    any_failed=1
    continue
  fi

  echo "[DEBUG] $profile | profile-directory=$profile_dir | ${#urls[@]} url(s)"
  "$chrome_exe" --new-window "--profile-directory=$profile_dir" "${urls[@]}" >/dev/null 2>&1 &
  sleep "$delay_seconds"
done

exit "$any_failed"
