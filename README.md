# Crimea Travel Platform

Crimea Travel Platform — greenfield-платформа для поиска туристических мест и
планирования маршрутов. Первый контентный контур посвящён Республике Крым, но
доменная модель поддерживает несколько стран и регионов:
`Country -> Region -> Locality -> Place`.

Проект не является официальным государственным приложением и не заявляет об
официальном партнёрстве с государственными организациями.

## Статус

Проект находится на стадии architecture and foundation. Реализованы skeleton
`tourism-backend` и `tourism-mobile` как private submodules. Production
infrastructure ещё не реализована.

## Архитектура repositories

Этот repository является Git superproject и фиксирует совместимые commits
компонентов через submodules:

```text
crimea-travel-platform/
├── tourism-platform/
├── tourism-mobile/
├── tourism-backend/
├── tourism-infrastructure/
└── tourism-documentation/
```

| Repository | Назначение | Статус |
| --- | --- | --- |
| [`tourism-platform`](tourism-platform) | Архитектура, local Compose и tooling | Foundation |
| [`tourism-mobile`](tourism-mobile) | Flutter application для Android и iOS | Foundation skeleton |
| [`tourism-backend`](tourism-backend) | Python/FastAPI modular monolith | Foundation skeleton |
| `tourism-infrastructure` | Kubernetes, Helm и environments | Planned |
| `tourism-documentation` | Расширенная документация | Planned |

Планируемые backend boundaries: `identity`, `users`, `geography`, `places`,
`routes`, `route_builder` и `media`. Они начинаются как modules одного backend
и выделяются в микросервисы только при подтверждённой необходимости.

## Технологическое направление

- Flutter, Riverpod, GoRouter, Dio и offline-first foundation.
- Python 3.13, FastAPI, Pydantic v2 и SQLAlchemy 2.
- PostgreSQL с PostGIS, Redis и S3-compatible storage.
- Provider-neutral `RoutingProvider`.
- Kafka как conditional event backbone будущих independently deployable
  services; broker runtime пока не добавлен.
- Docker Compose локально; Kubernetes и Helm в infrastructure repository.

## Начало работы

Клонирование со всеми submodules (требуется доступ к private GitLab group):

```bash
git clone --recurse-submodules \
  https://gitlab.com/crimea-travel-platform/crimea-travel-platform.git
cd crimea-travel-platform
make init
```

Первичная миграция или пересоздание remote projects на GitLab:

```bash
./scripts/migrate-to-gitlab.sh
```

Обновление submodule pointers:

```bash
make update
```

Запуск local infrastructure:

```bash
make up
```

## Документация

- [Product vision](tourism-platform/docs/product-vision.md)
- [System context](tourism-platform/docs/system-context.md)
- [Domain model](tourism-platform/docs/domain-model.md)
- [Repository strategy](tourism-platform/docs/repository-strategy.md)
- [Architecture decisions](tourism-platform/docs/decisions)
- [Preliminary event catalog](tourism-platform/docs/events/event-catalog.md)
- [Legacy analysis](tourism-platform/docs/legacy-project-analysis.md)

Legacy Android repository используется только как источник первоначальных
сценариев. Его code, architecture и resources не переносятся.

## Видимость проекта

Основной workspace размещён в private GitLab group
`crimea-travel-platform`. Доступ к implementation repositories выдаётся
участникам проекта. GitHub-зеркало больше не используется из-за trade control
ограничений на private repositories.
