# Документация workspace

Канонические документы живут в submodule `tourism-platform/docs/`, чтобы не
дублировать product/architecture content.

## Основные документы

| Документ | Путь |
| --- | --- |
| **Progress (что сделано / дальше)** | [../tourism-platform/docs/progress.md](../tourism-platform/docs/progress.md) |
| Geography/places DB model | [../tourism-platform/docs/data-model-geography-places.md](../tourism-platform/docs/data-model-geography-places.md) |
| AI route planning architecture | [../tourism-platform/docs/ai-route-planning-architecture.md](../tourism-platform/docs/ai-route-planning-architecture.md) |
| Бизнес-логика | [../tourism-platform/docs/application-business-logic.md](../tourism-platform/docs/application-business-logic.md) |
| План реализации | [../tourism-platform/docs/implementation-plan.md](../tourism-platform/docs/implementation-plan.md) |
| Conventions | [../tourism-platform/docs/development-conventions.md](../tourism-platform/docs/development-conventions.md) |
| Development environment (DX) | [../tourism-platform/docs/development-environment.md](../tourism-platform/docs/development-environment.md) |
| Python code style | [../tourism-platform/docs/python-code-style.md](../tourism-platform/docs/python-code-style.md) |
| Flutter code style | [../tourism-platform/docs/flutter-code-style.md](../tourism-platform/docs/flutter-code-style.md) |
| Domain model | [../tourism-platform/docs/domain-model.md](../tourism-platform/docs/domain-model.md) |
| Local development | [../tourism-platform/docs/local-development.md](../tourism-platform/docs/local-development.md) |
| Repository strategy | [../tourism-platform/docs/repository-strategy.md](../tourism-platform/docs/repository-strategy.md) |

## Development workflow (submodules)

1. Изменения коммитятся и мержатся в дочернем repository
   (`tourism-platform`, `tourism-backend`, `tourism-mobile`).
2. В `workspace` обновляется submodule pointer на нужный SHA.
3. Отдельный commit в `workspace` фиксирует совместимый набор версий.
4. `git push` только по явной договорённости; foundation-сессии могут
   оставлять изменения локально.

Порядок merge: сначала child repos, затем workspace pointer.

См. [development-conventions.md](../tourism-platform/docs/development-conventions.md).
