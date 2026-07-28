# Crimea Travel Platform

Crimea Travel Platform — greenfield-платформа для поиска туристических мест и
планирования маршрутов. Первый контентный контур посвящён Республике Крым, но
доменная модель поддерживает несколько стран и регионов:
`Country -> Region -> Locality -> Place`.

Проект не является официальным государственным приложением и не заявляет об
официальном партнёрстве с государственными организациями.

## Статус

Стадия foundation (Phase 0–1). Skeleton `tourism-backend` и `tourism-mobile`
подключены как private GitLab submodules. Local Compose готов; production
deploy ещё не реализован.

## Архитектура repositories

Этот repository (`workspace`) — Git superproject:

```text
workspace/
├── docs/                 # индекс канонической документации
├── tourism-platform/     # docs, Compose, будущие Helm/K8s
├── tourism-backend/      # FastAPI modular monolith
└── tourism-mobile/       # Flutter app
```

| Repository | Назначение | Статус |
| --- | --- | --- |
| [`tourism-platform`](tourism-platform) | Docs, local Compose, infra assets | Foundation |
| [`tourism-backend`](tourism-backend) | Python/FastAPI modular monolith | Foundation skeleton |
| [`tourism-mobile`](tourism-mobile) | Flutter Android/iOS | Foundation skeleton |

Дополнительные repositories не создаются. Kubernetes/Helm и продуктовая
документация живут в `tourism-platform`.

Backend module boundaries: `identity`, `users`, `geography`, `places`,
`routes`, `route_builder`, `route_execution`, `favorites`, `subscriptions`,
`media`.

## Технологическое направление

- Flutter, Riverpod, GoRouter, Dio.
- Python 3.13, FastAPI, Pydantic v2, SQLAlchemy 2.
- PostgreSQL/PostGIS, Redis, S3-compatible storage (MinIO local).
- Provider-neutral `RoutingProvider`.
- Kafka только после подтверждённого сценария (ADR-005).
- Docker Compose локально; GitLab CI; Helm позже в `tourism-platform`.

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
| `make validate` | Безопасные проверки |
| `make update` | Обновить submodule pointers (затем закоммитить) |
| `make clean CONFIRM=yes` | Удалить volumes |

## Документация

Канон находится в `tourism-platform/docs/`. Индекс: [docs/README.md](docs/README.md).

- [Progress — что сделано / дальше](tourism-platform/docs/progress.md)
- [Business logic](tourism-platform/docs/application-business-logic.md)
- [Implementation plan](tourism-platform/docs/implementation-plan.md)
- [Development conventions](tourism-platform/docs/development-conventions.md)
- [Product vision](tourism-platform/docs/product-vision.md)
- [Domain model](tourism-platform/docs/domain-model.md)
- [Repository strategy](tourism-platform/docs/repository-strategy.md)
- [Local development](tourism-platform/docs/local-development.md)
- [Architecture decisions](tourism-platform/docs/decisions)

Legacy Android repository — только источник сценариев, код не переносится.

## Видимость

```text
gitlab.com/travel-platform2/
├── workspace/
├── tourism-platform/
├── tourism-backend/
└── tourism-mobile/
```

Источник истины — GitLab. GitHub — public showcase mirror
(`xotabeach/workspace`, `tourism-platform`, `tourism-backend`, `tourism-mobile`).

Автосинхронизация: GitLab CI job `github-mirror` на push в `gamma`/`main`
(после зелёных `code-style` + `run-tests`). Нужны group variables
`GITHUB_MIRROR_TOKEN` и `GITHUB_MIRROR_OWNER` — см.
`tourism-platform/docs/development-conventions.md`.
