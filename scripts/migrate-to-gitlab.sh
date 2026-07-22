#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SUPERPROJECT_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
GITLAB_HOST="${GITLAB_HOST:-gitlab.com}"
GITLAB_NAMESPACE="${GITLAB_NAMESPACE:-}"
GITLAB_VISIBILITY="${GITLAB_VISIBILITY:-private}"
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
  printf '  glab auth login --hostname %s --web\n' "${GITLAB_HOST}" >&2
  exit 1
fi

if [[ -z "${GITLAB_NAMESPACE}" ]]; then
  GITLAB_NAMESPACE="$(glab api user | python3 -c 'import json,sys; print(json.load(sys.stdin)["username"])')"
fi

GITLAB_BASE_URL="https://${GITLAB_HOST}/${GITLAB_NAMESPACE}"

printf 'Using GitLab namespace %s\n' "${GITLAB_NAMESPACE}"

for entry in "${REPOSITORIES[@]}"; do
  repository_name="${entry%%:*}"
  repository_path="${entry##*:}"
  repository_dir="${SUPERPROJECT_ROOT}/${repository_path}"
  remote_url="${GITLAB_BASE_URL}/${repository_name}.git"
  project_slug="${GITLAB_NAMESPACE}%2F${repository_name}"

  if [[ ! -d "${repository_dir}/.git" ]]; then
    printf 'Error: %s is not a Git repository.\n' "${repository_dir}" >&2
    exit 1
  fi

  printf 'Ensuring project %s/%s exists...\n' "${GITLAB_NAMESPACE}" "${repository_name}"
  if ! glab api "projects/${project_slug}" >/dev/null 2>&1; then
    if [[ "${GITLAB_VISIBILITY}" == "private" ]]; then
      glab repo create "${GITLAB_NAMESPACE}/${repository_name}" \
        --description "Crimea Travel Platform ${repository_name}" \
        --defaultBranch main \
        --private
    else
      glab repo create "${GITLAB_NAMESPACE}/${repository_name}" \
        --description "Crimea Travel Platform ${repository_name}" \
        --defaultBranch main
    fi
  fi

  printf 'Pushing %s to %s...\n' "${repository_name}" "${remote_url}"
  git -C "${repository_dir}" remote set-url origin "${remote_url}"
  git -C "${repository_dir}" push -u origin main
done

if [[ -d "${SUPERPROJECT_ROOT}/.git/modules/tourism-platform" ]]; then
  printf 'Updating submodule URLs in superproject...\n'
  git -C "${SUPERPROJECT_ROOT}" submodule set-url tourism-platform \
    "${GITLAB_BASE_URL}/tourism-platform.git"
  git -C "${SUPERPROJECT_ROOT}" submodule set-url tourism-backend \
    "${GITLAB_BASE_URL}/tourism-backend.git"
  git -C "${SUPERPROJECT_ROOT}" submodule set-url tourism-mobile \
    "${GITLAB_BASE_URL}/tourism-mobile.git"
  git -C "${SUPERPROJECT_ROOT}" submodule sync --recursive
fi

printf 'Migration complete.\n'
printf 'GitLab namespace: %s\n' "${GITLAB_BASE_URL}"
printf 'Clone with:\n'
printf '  git clone --recurse-submodules git@%s:%s/crimea-travel-platform.git\n' \
  "${GITLAB_HOST}" "${GITLAB_NAMESPACE}"
