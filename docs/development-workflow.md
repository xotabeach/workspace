# Development workflow

Краткий порядок работы в superproject. Полные conventions:
[tourism-platform/docs/development-conventions.md](../tourism-platform/docs/development-conventions.md).
Стек: [tourism-platform/docs/stack.md](../tourism-platform/docs/stack.md).

## Локальный день разработчика

1. `make init` (один раз) и `make up` (PostGIS, Redis, MinIO, Mailpit).
2. Backend: `cd tourism-backend && uv sync --all-extras --dev`,
   `uv run alembic upgrade head`, `uv run tourism-backend`.
3. Mobile: `cd tourism-mobile && flutter pub get && flutter run`.
4. Перед MR: `./scripts/validate.sh` в затронутом repo (GitLab CI lean).

Ollama / Gemma 4 в этот день **не** входят — home lab отдельно, см. stack.md.

## Commit order для cross-repo изменений

1. Child repository MR → merge в `main`.
2. Обновить submodule SHA в workspace.
3. Workspace commit с message вида
   `chore: bump tourism-backend to <sha>`.

Не коммитить secrets. Не делать `git push` без явной просьбы.
