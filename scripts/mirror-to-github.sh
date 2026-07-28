#!/usr/bin/env bash

# Local/manual GitHub showcase mirror.
# Primary development stays on GitLab. This pushes public mirrors only.
#
# Usage:
#   ./scripts/mirror-to-github.sh
# Env:
#   GITHUB_OWNER      default: xotabeach
#   GITHUB_VISIBILITY default: public
#   GITHUB_BRANCH     source branch to push (default: current branch)

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SUPERPROJECT_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
GITHUB_OWNER="${GITHUB_OWNER:-xotabeach}"
GITHUB_VISIBILITY="${GITHUB_VISIBILITY:-public}"
GITHUB_BRANCH="${GITHUB_BRANCH:-$(git -C "${SUPERPROJECT_ROOT}" branch --show-current)}"

SHOWCASE_REPOS=(
  workspace:${SUPERPROJECT_ROOT}
  tourism-platform:${SUPERPROJECT_ROOT}/tourism-platform
  tourism-backend:${SUPERPROJECT_ROOT}/tourism-backend
  tourism-mobile:${SUPERPROJECT_ROOT}/tourism-mobile
)

require_command() {
  local command_name="$1"

  if ! command -v "${command_name}" >/dev/null 2>&1; then
    printf 'Error: required command "%s" not found.\n' "${command_name}" >&2
    exit 1
  fi
}

require_command git
require_command gh

if ! gh auth status >/dev/null 2>&1; then
  printf 'Error: GitHub CLI is not authenticated. Run "gh auth login".\n' >&2
  exit 1
fi

create_repo_if_missing() {
  local repository_name="$1"
  local repository_dir="$2"
  local remote_url="https://github.com/${GITHUB_OWNER}/${repository_name}.git"
  local gh_visibility_flag=()

  if [[ "${GITHUB_VISIBILITY}" == "private" ]]; then
    gh_visibility_flag=(--private)
  else
    gh_visibility_flag=(--public)
  fi

  if ! gh repo view "${GITHUB_OWNER}/${repository_name}" >/dev/null 2>&1; then
    printf 'Creating GitHub repo %s/%s...\n' "${GITHUB_OWNER}" "${repository_name}"
    gh repo create "${GITHUB_OWNER}/${repository_name}" \
      "${gh_visibility_flag[@]}" \
      --description "Crimea Travel Platform showcase mirror: ${repository_name}"
  fi

  if git -C "${repository_dir}" remote | grep -qx github; then
    git -C "${repository_dir}" remote set-url github "${remote_url}"
  else
    git -C "${repository_dir}" remote add github "${remote_url}"
  fi

  printf 'Pushing %s (%s → github %s + main)...\n' \
    "${repository_name}" "${GITHUB_BRANCH}" "${GITHUB_BRANCH}"
  git -C "${repository_dir}" push --force github "${GITHUB_BRANCH}:${GITHUB_BRANCH}"
  if [[ "${GITHUB_BRANCH}" == "gamma" || "${GITHUB_BRANCH}" == "main" ]]; then
    git -C "${repository_dir}" push --force github "${GITHUB_BRANCH}:main"
  fi
}

for entry in "${SHOWCASE_REPOS[@]}"; do
  repository_name="${entry%%:*}"
  repository_dir="${entry##*:}"
  create_repo_if_missing "${repository_name}" "${repository_dir}"
done

printf '\nGitHub showcase mirror updated.\n'
printf 'Primary development remains on GitLab.\n'
printf 'Automatic sync: GitLab CI job github-mirror on gamma/main.\n'
printf 'Showcase URLs:\n'
printf '  https://github.com/%s/workspace\n' "${GITHUB_OWNER}"
printf '  https://github.com/%s/tourism-platform\n' "${GITHUB_OWNER}"
printf '  https://github.com/%s/tourism-backend\n' "${GITHUB_OWNER}"
printf '  https://github.com/%s/tourism-mobile\n' "${GITHUB_OWNER}"
