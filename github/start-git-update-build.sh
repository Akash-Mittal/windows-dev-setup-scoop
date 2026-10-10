#!/usr/bin/env bash
set -euo pipefail

CSV_PATH="${1:-"$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../windows_dev_setup.csv"}"
GITHUB_ROOT="${GITHUB_ROOT:-"$HOME/github"}"

if [[ ! -f "$CSV_PATH" ]]; then
  echo "[ERROR] windows_dev_setup.csv not found: $CSV_PATH" >&2
  exit 1
fi

if [[ ! -d "$GITHUB_ROOT" ]]; then
  echo "[ERROR] GitHub root folder not found: $GITHUB_ROOT" >&2
  exit 1
fi

any_failed=0

# Rows in worksheet github_repos: config = repo path, value = build command.
repos="$(awk -F',' '
  function clean(s) { gsub(/\r/, "", s); gsub(/^[ \t"]+|[ \t"]+$/, "", s); return s }
  NR == 1 { next }
  tolower(clean($1)) == "github_repos" {
    cmd = $3; for (i = 4; i <= NF; i++) cmd = cmd "," $i
    print clean($2) "\t" clean(cmd)
  }
' "$CSV_PATH")"

if [[ -z "$repos" ]]; then
  echo "[ERROR] No repos found in worksheet github_repos in $CSV_PATH" >&2
  exit 1
fi

while IFS=$'\t' read -r raw_path build_cmd <&3; do
  [[ -z "$raw_path" ]] && continue

  rel_path="${raw_path#github/}"
  rel_path="${rel_path#github\\}"
  rel_path="${rel_path//\\//}"

  repo_path="$GITHUB_ROOT/$rel_path"
  repo_name="$(basename "$repo_path")"

  echo "========================================"
  echo "[DEBUG] Repo: $repo_path"

  if [[ ! -d "$repo_path" ]]; then
    echo "[ERROR] $repo_name | Path not found: $repo_path" >&2
    any_failed=1
    continue
  fi

  if [[ ! -d "$repo_path/.git" ]]; then
    echo "[ERROR] $repo_name | Not a git repo (missing .git): $repo_path" >&2
    any_failed=1
    continue
  fi

  (
    cd "$repo_path"

    echo "[DEBUG] $repo_name | git fetch"
    git fetch origin --prune

    echo "[DEBUG] $repo_name | git checkout main -> origin/HEAD"
    git checkout -B main origin/HEAD

    echo "[DEBUG] $repo_name | git reset --hard origin/HEAD"
    git reset --hard origin/HEAD

    echo "[DEBUG] $repo_name | git clean -fdx"
    git clean -fdx

    if [[ -n "$build_cmd" ]]; then
      echo "[DEBUG] $repo_name | build: $build_cmd"
      bash -lc "$build_cmd"
      echo "[DEBUG] $repo_name | BUILD OK"
    else
      echo "[DEBUG] $repo_name | No buildCommand set, skipping build"
    fi
  ) || {
    echo "[ERROR] $repo_name | FAILED" >&2
    any_failed=1
    continue
  }
done 3<<< "$repos"

echo "========================================"
if [[ "$any_failed" -ne 0 ]]; then
  echo "[ERROR] One or more repositories failed." >&2
  exit 1
fi

echo "[DEBUG] All repositories updated and built successfully."
