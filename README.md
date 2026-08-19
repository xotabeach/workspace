# Crimea Travel Platform

Crimea Travel Platform (CrimeaTrip) — greenfield-платформа для поиска
туристических мест и планирования маршрутов. Первый контентный контур —
Республика Крым; доменная модель: `Country -> Region -> Locality -> Place`.

Проект не является официальным государственным приложением и не заявляет об
официальном партнёрстве с государственными организациями.

## Статус

Рабочий продукт, не foundation-skeleton. Каталог, auth (OTP/JWT), избранное,
публикация маршрутов + SQLAdmin, профиль (тп/звания/лидерборд), отзывы,
inbox + FCM (Android) — as-built. Test-backend задеплоен на отдельный host.

**Дальше по плану:** enrichment slug/описаний и PostGIS quality gate для 1000
локальных и 1000 серверных draft places, затем Phase 8A (deterministic Route
Builder). Выбранный AI home lab — Windows LM Studio + **Unsloth Gemma 4 26B
A4B it UD-IQ4_XS**; connectivity adapter/probe уже есть, planning API ещё нет. Живой лог:
[progress.md](tourism-platform/docs/progress.md).

Полный стек (local / test / home-lab Gemma):
[stack.md](tourism-platform/docs/stack.md).

## Архитектура repositories

Этот repository (`workspace`) — Git superproject:

```text
workspace/
├── docs/                 # индекс канонической документации
├── tourism-platform/     # docs, Compose, deploy/test
├── tourism-backend/      # FastAPI modular monolith
└── tourism-mobile/       # Flutter app
```

| Repository | Назначение |
| --- | --- |
| [`tourism-platform`](tourism-platform) | Docs, local Compose, test deploy |
| [`tourism-backend`](tourism-backend) | Python 3.13 / FastAPI modular monolith |
| [`tourism-mobile`](tourism-mobile) | Flutter Android/iOS |

Дополнительные repositories не создаются. Kubernetes/Helm — позже в
`tourism-platform`, не отдельным infra-repo.

Backend modules (с API): `identity`, `geography`, `places`, `routes`,
`favorites`, `support`, `notifications`, `admin`, `media`.
Ещё stub: `route_builder`, `route_execution`, `subscriptions`.

## Технологическое направление

Сводка: [stack.md](tourism-platform/docs/stack.md). Кратко:

- Flutter, Riverpod, GoRouter, Dio.
- Python 3.13, FastAPI, Pydantic v2, SQLAlchemy 2.
- PostgreSQL/PostGIS, Redis; MinIO и Mailpit — local DX.
- Test host: Caddy + backend + PostGIS + Redis.
- AI (план): `AIPlanningProvider` → mock / Gemini / **LM Studio Unsloth Gemma
  4 26B A4B it UD-IQ4_XS**; Ollama остаётся альтернативным transport; Qdrant
  RAG — отдельно.
- Kafka только после ADR-005. Helm — только при реальной multi-node нужде.
- GitLab CI lean; локально `./scripts/validate.sh`.

## Начало работы

```bash
git clone --recurse-submodules \
  https://gitlab.com/travel-platform2/workspace.git
cd workspace
make init
make up
```

Для SSH вместо HTTPS локально:

```bash
git config --global url."git@gitlab.com:".insteadOf "https://gitlab.com/"
```

| Команда | Назначение |
| --- | --- |
| `make init` | Submodules + platform `.env` |
| `make up` / `down` / `ps` / `logs` | Local infrastructure |
| `make validate` | Проверки tourism-platform |
| `make update` | Обновить submodule pointers (затем закоммитить) |
| `make clean CONFIRM=yes` | Удалить volumes |

Backend и mobile — в своих каталогах (`uv run tourism-backend`,
`flutter run`). CI style/tests в lean-режиме не гоняются на GitLab:
`cd tourism-backend && ./scripts/validate.sh` (и аналогично mobile).

## Документация

Канон находится в `tourism-platform/docs/`. Индекс: [docs/README.md](docs/README.md).

- [Стек (local / test / Gemma 4)](tourism-platform/docs/stack.md)
- [Progress — что сделано / дальше](tourism-platform/docs/progress.md)
- [Business logic](tourism-platform/docs/application-business-logic.md)
- [Implementation plan](tourism-platform/docs/implementation-plan.md)
- [Development conventions](tourism-platform/docs/development-conventions.md)
- [Product vision](tourism-platform/docs/product-vision.md)
- [Domain model](tourism-platform/docs/domain-model.md)
- [Repository strategy](tourism-platform/docs/repository-strategy.md)
- [Local development](tourism-platform/docs/local-development.md)
- [Architecture decisions](tourism-platform/docs/decisions)
- [Windows LM Studio + Gemma 4 26B](tourism-platform/docs/ai-lm-studio-windows-gemma4.md)
- [PostGIS bulk import 1000+](tourism-platform/docs/crimea-places-bulk-import-plan.md)
- [AI-чат и генерация маршрута](tourism-platform/docs/ai-route-chat-mobile-implementation.md)
- [CI / runners](tourism-platform/docs/ci-and-runners.md)

Legacy Android repository — только источник сценариев, код не переносится.

## Видимость

```text
gitlab.com/travel-platform2/
├── workspace/
├── tourism-platform/
├── tourism-backend/
└── tourism-mobile/
```

Источник истины — GitLab. GitHub mirror (опционально) — только public showcase.
