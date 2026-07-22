#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SUPERPROJECT_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
GITHUB_ORG="${GITHUB_ORG:-travel-platform}"
GITHUB_VISIBILITY="${GITHUB_VISIBILITY:-public}"

SHOWCASE_REPOS=(
  tourism-platform:${SUPERPROJECT_ROOT}/tourism-platform
  workspace:${SUPERPROJECT_ROOT}
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

if ! gh api "orgs/${GITHUB_ORG}" >/dev/null 2>&1; then
  printf 'GitHub organization "%s" was not found.\n' "${GITHUB_ORG}" >&2
  printf 'Create it at https://github.com/organizations/plan without regional names,\n' >&2
  printf 'then rerun ./scripts/mirror-to-github.sh\n' >&2
  exit 1
fi

create_repo_if_missing() {
  local repository_name="$1"
  local repository_dir="$2"
  local remote_url="git@github.com:${GITHUB_ORG}/${repository_name}.git"
  local gh_visibility_flag=()

  if [[ "${GITHUB_VISIBILITY}" == "private" ]]; then
    gh_visibility_flag=(--private)
  else
    gh_visibility_flag=(--public)
  fi

  if ! gh repo view "${GITHUB_ORG}/${repository_name}" >/dev/null 2>&1; then
    printf 'Creating GitHub repo %s/%s...\n' "${GITHUB_ORG}" "${repository_name}"
    gh repo create "${GITHUB_ORG}/${repository_name}" \
      "${gh_visibility_flag[@]}" \
      --description "Crimea Travel Platform showcase mirror: ${repository_name}"
  fi

  if git -C "${repository_dir}" remote | grep -qx github; then
    git -C "${repository_dir}" remote set-url github "${remote_url}"
  else
    git -C "${repository_dir}" remote add github "${remote_url}"
  fi

  printf 'Pushing %s to GitHub...\n' "${repository_name}"
  git -C "${repository_dir}" push github main
}

for entry in "${SHOWCASE_REPOS[@]}"; do
  repository_name="${entry%%:*}"
  repository_dir="${entry##*:}"
  create_repo_if_missing "${repository_name}" "${repository_dir}"
done

printf '\nGitHub showcase mirror updated.\n'
printf 'Primary development remains on GitLab.\n'
printf 'Showcase URLs:\n'
printf '  https://github.com/%s/tourism-platform\n' "${GITHUB_ORG}"
printf '  https://github.com/%s/workspace\n' "${GITHUB_ORG}"
