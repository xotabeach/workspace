#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SUPERPROJECT_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
GITLAB_HOST="${GITLAB_HOST:-gitlab.com}"
GITLAB_GROUP="${GITLAB_GROUP:-travel-platform}"
SUPERPROJECT_NAME="${SUPERPROJECT_NAME:-workspace}"

PROJECTS=(
  crimea-travel-platform
  tourism-platform
  tourism-backend
  tourism-mobile
)

require_command() {
  local command_name="$1"

  if ! command -v "${command_name}" >/dev/null 2>&1; then
    printf 'Error: required command "%s" not found.\n' "${command_name}" >&2
    exit 1
  fi
}

require_command glab
require_command git

if ! glab auth status --hostname "${GITLAB_HOST}" >/dev/null 2>&1; then
  printf 'Error: run "glab auth login --hostname %s --web".\n' "${GITLAB_HOST}" >&2
  exit 1
fi

printf 'Checking GitLab group %s...\n' "${GITLAB_GROUP}"
if ! glab api "groups/${GITLAB_GROUP}" >/dev/null 2>&1; then
  printf '\nGroup "%s" was not found.\n' "${GITLAB_GROUP}" >&2
  printf 'On GitLab.com top-level groups can only be created in the UI:\n' >&2
  printf '  https://gitlab.com/groups/new\n\n' >&2
  printf 'Create a private group with path "%s", then rerun:\n' "${GITLAB_GROUP}" >&2
  printf '  ./scripts/setup-gitlab-group.sh\n' >&2
  exit 1
fi

group_id="$(glab api "groups/${GITLAB_GROUP}" | python3 -c 'import json,sys; print(json.load(sys.stdin)["id"])')"
printf 'Using group %s (id=%s)\n' "${GITLAB_GROUP}" "${group_id}"

for project in "${PROJECTS[@]}"; do
  current_path="xotabeach/${project}"
  printf 'Transferring %s into %s...\n' "${current_path}" "${GITLAB_GROUP}"

  if glab api "projects/${GITLAB_GROUP}%2F${project}" >/dev/null 2>&1; then
    printf 'Already in group: %s/%s\n' "${GITLAB_GROUP}" "${project}"
    continue
  fi

  if ! glab api "projects/xotabeach%2F${project}" >/dev/null 2>&1; then
    printf 'Error: project %s not found under xotabeach.\n' "${project}" >&2
    exit 1
  fi

  glab api --method PUT "projects/xotabeach%2F${project}/transfer" \
    -f namespace="${group_id}"
done

if glab api "projects/${GITLAB_GROUP}%2Fcrimea-travel-platform" >/dev/null 2>&1 && \
  ! glab api "projects/${GITLAB_GROUP}%2F${SUPERPROJECT_NAME}" >/dev/null 2>&1; then
  printf 'Renaming superproject path to %s...\n' "${SUPERPROJECT_NAME}"
  superproject_id="$(glab api "projects/${GITLAB_GROUP}%2Fcrimea-travel-platform" | \
    python3 -c 'import json,sys; print(json.load(sys.stdin)["id"])')"
  glab api --method PUT "projects/${superproject_id}" -f path="${SUPERPROJECT_NAME}"
fi

new_base="https://${GITLAB_HOST}/${GITLAB_GROUP}"

for path in tourism-platform tourism-backend tourism-mobile; do
  remote="${new_base}/${path}.git"
  git -C "${SUPERPROJECT_ROOT}/${path}" remote set-url origin "${remote}"
  git -C "${SUPERPROJECT_ROOT}/${path}" submodule sync --recursive >/dev/null 2>&1 || true
  printf 'Updated remote for %s\n' "${path}"
done

git -C "${SUPERPROJECT_ROOT}" remote set-url origin "${new_base}/${SUPERPROJECT_NAME}.git"
git -C "${SUPERPROJECT_ROOT}" submodule set-url tourism-platform "${new_base}/tourism-platform.git"
git -C "${SUPERPROJECT_ROOT}" submodule set-url tourism-backend "${new_base}/tourism-backend.git"
git -C "${SUPERPROJECT_ROOT}" submodule set-url tourism-mobile "${new_base}/tourism-mobile.git"
git -C "${SUPERPROJECT_ROOT}" submodule sync --recursive

printf '\nGroup setup complete.\n'
printf 'Clone with:\n'
printf '  git clone --recurse-submodules %s/%s.git\n' "${new_base}" "${SUPERPROJECT_NAME}"
printf '\nCommit and push .gitmodules / remote changes from the superproject.\n'
