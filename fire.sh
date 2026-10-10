#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

CSV_PATH="${1:-"$SCRIPT_DIR/windows_dev_setup.csv"}"
USER_HOME="${USERPROFILE:-$HOME}"
if command -v cygpath >/dev/null 2>&1; then
  USER_HOME="$(cygpath -u "$USER_HOME")"
fi

to_win_path() {
  if command -v cygpath >/dev/null 2>&1; then
    cygpath -w "$1"
  else
    echo "$1"
  fi
}

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

install_on_startup="$(get_config "install-configs" "installonstartup" "true")"

if [[ "${install_on_startup,,}" == "true" ]]; then
  scoop_setup="$SCRIPT_DIR/scoop/start-scoop-windows-setup.ps1"
  if [[ ! -f "$scoop_setup" ]]; then
    echo "[ERROR] Setup script not found at $scoop_setup" >&2
    exit 1
  fi
  powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$(to_win_path "$scoop_setup")"
fi

git config core.longpaths true 2>/dev/null || true
git config --global core.longpaths true 2>/dev/null || true
composer update
composer global require laravel/installer

# name|path|arguments (space separated)
startup_items=(
  "AutoHotkey|$SCRIPT_DIR/autohotkey/start-vpn-login.ahk|"
  "Docker Desktop|/c/Program Files/Docker/Docker/Docker Desktop.exe|"
  "Chrome Browser|$SCRIPT_DIR/chrome/start-chrome.ps1|personal work finance"
  "Rainmeter|$USER_HOME/scoop/apps/rainmeter/current/rainmeter.exe|"
  "IntelliJ IDEA Ultimate|$USER_HOME/scoop/apps/idea-ultimate/current/IDE/bin/idea64.exe|"
  "Notepad++|$USER_HOME/scoop/apps/notepadplusplus/current/notepad++.exe|"
  "Open Notepad Files|$SCRIPT_DIR/notepad/start-open-default-text-files.ps1|"
  "NoSleep|$USER_HOME/scoop/apps/nosleep/current/NoSleep.exe|"
  "Clear Cache|$SCRIPT_DIR/clear-cache/start-clear-cache.ps1|"
  "Start Docker Compose|$SCRIPT_DIR/docker/start-docker.ps1|"
  "MongoDB Compass|$USER_HOME/scoop/apps/mongodb-compass/current/MongoDBCompass.exe|"
  "Scoop Update|$SCRIPT_DIR/scoop/start-scoop-update.ps1|"
  "Git Update and Build|$SCRIPT_DIR/github/start-git-update-build.sh|"
)

for item in "${startup_items[@]}"; do
  IFS='|' read -r name path args <<< "$item"
  read -r -a arg_list <<< "$args"

  if [[ ! -f "$path" ]]; then
    echo "[WARN] $name not found at $path. Application not started." >&2
    continue
  fi

  case "${path,,}" in
    *.ps1)
      powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$(to_win_path "$path")" "${arg_list[@]}" &
      ;;
    *.sh)
      bash "$path" "${arg_list[@]}" &
      ;;
    *)
      cmd.exe //c start "" "$(to_win_path "$path")" "${arg_list[@]}" &
      ;;
  esac
done
