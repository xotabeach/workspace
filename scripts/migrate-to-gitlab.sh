#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SUPERPROJECT_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
GITLAB_HOST="${GITLAB_HOST:-gitlab.com}"
GITLAB_GROUP="${GITLAB_GROUP:-crimea-travel-platform}"
GITLAB_VISIBILITY="${GITLAB_VISIBILITY:-private}"
GITLAB_BASE_URL="https://${GITLAB_HOST}/${GITLAB_GROUP}"

REPOSITORIES=(
  crimea-travel-platform:.
  tourism-platform:tourism-platform
  tourism-backend:tourism-backend
  tourism-mobile:tourism-mobile
)

require_command() {
  local command_name="$1"

  if ! command -v "${command_name}" >/dev/null 2>&1; then
    printf 'Error: required command "%s" not found.\n' "${command_name}" >&2
    exit 1
  fi
}

require_command git
require_command glab

if ! glab auth status --hostname "${GITLAB_HOST}" >/dev/null 2>&1; then
  printf 'Error: GitLab CLI is not authenticated. Run:\n' >&2
  printf '  glab auth login --hostname %s\n' "${GITLAB_HOST}" >&2
  exit 1
fi

printf 'Ensuring GitLab group %s exists...\n' "${GITLAB_GROUP}"
if ! glab api "groups/${GITLAB_GROUP}" >/dev/null 2>&1; then
  glab api --method POST groups \
    -f name="${GITLAB_GROUP}" \
    -f path="${GITLAB_GROUP}" \
    -f visibility="${GITLAB_VISIBILITY}" \
    -f description="Crimea Travel Platform workspace"
fi

for entry in "${REPOSITORIES[@]}"; do
  repository_name="${entry%%:*}"
  repository_path="${entry##*:}"
  repository_dir="${SUPERPROJECT_ROOT}/${repository_path}"
  remote_url="${GITLAB_BASE_URL}/${repository_name}.git"

  if [[ ! -d "${repository_dir}/.git" ]]; then
    printf 'Error: %s is not a Git repository.\n' "${repository_dir}" >&2
    exit 1
  fi

  printf 'Ensuring project %s/%s exists...\n' "${GITLAB_GROUP}" "${repository_name}"
  if ! glab api "projects/${GITLAB_GROUP}%2F${repository_name}" >/dev/null 2>&1; then
    glab repo create "${GITLAB_GROUP}/${repository_name}" \
      --description "Crimea Travel Platform ${repository_name}" \
      --defaultBranch main \
      --private
  fi

  printf 'Pushing %s to %s...\n' "${repository_name}" "${remote_url}"
  git -C "${repository_dir}" remote set-url origin "${remote_url}"
  git -C "${repository_dir}" push -u origin main
done

printf 'Updating submodule URLs in superproject...\n'
git -C "${SUPERPROJECT_ROOT}" submodule set-url tourism-platform \
  "${GITLAB_BASE_URL}/tourism-platform.git"
git -C "${SUPERPROJECT_ROOT}" submodule set-url tourism-backend \
  "${GITLAB_BASE_URL}/tourism-backend.git"
git -C "${SUPERPROJECT_ROOT}" submodule set-url tourism-mobile \
  "${GITLAB_BASE_URL}/tourism-mobile.git"
git -C "${SUPERPROJECT_ROOT}" submodule sync --recursive

printf 'Migration complete.\n'
printf 'GitLab group: %s\n' "${GITLAB_BASE_URL}"
printf 'Clone with:\n'
printf '  git clone --recurse-submodules %s/crimea-travel-platform.git\n' \
  "${GITLAB_BASE_URL}"
