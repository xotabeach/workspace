---
name: travel-platform-local-ci
description: >-
  Run local quality gates (validate.sh / security tests) for CrimeaTrip
  tourism-backend, tourism-mobile, and tourism-platform while GitLab CI is in
  lean mode. Use before commit, push, claiming checks passed, finishing a
  feature, or when the user asks to validate / run CI locally.
---

# Travel platform local CI

GitLab default pipelines are **lean** (deploy/APK/mirror only). Style, types,
tests, and most scanners are **not** enforced on shared runners. Local
validation replaces them during active development.

Canonical policy: `tourism-platform/docs/ci-and-runners.md`.

## When to run

Run before:

- Creating a commit the user asked for
- Pushing (when the user asks to push)
- Saying tests / analyze / lint / security checks passed
- Finishing backend, mobile, or platform doc/CI changes

Do **not** claim a check passed unless you executed it in this session and
report the real command result.

## What to run (touched repos only)

| Changed area | Command | Notes |
| --- | --- | --- |
| `tourism-backend/**` | `cd tourism-backend && ./scripts/validate.sh` | ruff, format, mypy, pip-audit, full pytest |
| Backend security-sensitive | also `uv run pytest tests/security -q --no-cov` if validate already ran full pytest, skip duplicate | validate already includes pytest |
| `tourism-mobile/**` | `cd tourism-mobile && ./scripts/validate.sh` | format, analyze, test (+ macOS goldens) |
| Mobile UI / client input | ensure `flutter test test/security` covered (part of `flutter test`) | |
| `tourism-platform/**` | `cd tourism-platform && ./scripts/validate.sh` | required files, compose, markdownlint, yamllint |

If Docker/Postgres for backend tests is unavailable, say so and run at least
`uv run ruff check .`, `uv run ruff format --check .`, `uv run mypy src/tourism_backend`
instead of inventing a green status.

## Full GitLab pipeline

Do not enable `CI_PIPELINE_MODE=full` unless the user asks. For a release or
security push, remind them they can set that variable (see
`ci-and-runners.md`).

## Out of scope

- Do not start production deploy
- Do not buy minutes or register runners unless asked
- Do not skip security regressions on auth/upload/API/UI changes
  (see skill `travel-platform-security-audit` and security-baseline rule)
