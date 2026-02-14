#!/usr/bin/env bash
set -euo pipefail

JSON_PATH="${1:-"$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/github.json"}"
GITHUB_ROOT="${GITHUB_ROOT:-"$HOME/github"}"

if [[ ! -f "$JSON_PATH" ]]; then
  echo "[ERROR] github.json not found: $JSON_PATH" >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "[ERROR] jq not found. Install it:" >&2
  echo "  - Git Bash (Windows): pacman -S jq" >&2
  echo "  - Ubuntu/WSL: sudo apt-get update && sudo apt-get install -y jq" >&2
  exit 1
fi

if [[ ! -d "$GITHUB_ROOT" ]]; then
  echo "[ERROR] GitHub root folder not found: $GITHUB_ROOT" >&2
  exit 1
fi

any_failed=0

repo_count="$(jq '.github.repos | length' "$JSON_PATH")"
if [[ "$repo_count" -eq 0 ]]; then
  echo "[ERROR] No repos found at github.repos in $JSON_PATH" >&2
  exit 1
fi

for i in $(seq 0 $((repo_count - 1))); do
  raw_path="$(jq -r ".github.repos[$i].path // empty" "$JSON_PATH")"
  build_cmd="$(jq -r ".github.repos[$i].buildCommand // empty" "$JSON_PATH")"

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
done

echo "========================================"
if [[ "$any_failed" -ne 0 ]]; then
  echo "[ERROR] One or more repositories failed." >&2
  exit 1
fi

echo "[DEBUG] All repositories updated and built successfully."
