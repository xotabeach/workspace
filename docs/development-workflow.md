# Development workflow

Краткий порядок работы в superproject. Полные conventions:
[tourism-platform/docs/development-conventions.md](../tourism-platform/docs/development-conventions.md).

## Локальный день разработчика

1. `make init` (один раз) и `make up`.
2. Backend: `cd tourism-backend && uv sync --all-extras --dev` и
   `uv run tourism-backend` (после Phase 1 ready к DB/Redis).
3. Mobile: `cd tourism-mobile && flutter pub get && flutter run`.
4. Перед MR: validate в соответствующем repo.

## Commit order для cross-repo изменений

1. Child repository MR → merge в `main`.
2. Обновить submodule SHA в workspace.
3. Workspace commit с message вида
   `chore: bump tourism-backend to <sha>`.

Не коммитить secrets. Не делать `git push` без явной просьбы в foundation
сессиях, если команда не договорилась иначе.
