# Документация workspace

`workspace` фиксирует совместимые версии четырёх submodules. Общая продуктовая и
архитектурная документация находится в `tourism-platform/docs/`; здесь —
публичный индекс документов, которые входят в Git.

| Тема | Документы |
| --- | --- |
| Текущие возможности | [Статус](../tourism-platform/docs/current-status.md), [README backend](../tourism-backend/README.md), [README mobile](../tourism-mobile/README.md), [README landing](../tourism-landing/README.md) |
| Продукт и домен | [Видение](../tourism-platform/docs/product-vision.md), [бизнес-логика](../tourism-platform/docs/application-business-logic.md), [доменная модель](../tourism-platform/docs/domain-model.md) |
| Архитектура | [Системный контекст](../tourism-platform/docs/system-context.md), [стек](../tourism-platform/docs/stack.md), [ADR](../tourism-platform/docs/decisions), [стратегия репозиториев](../tourism-platform/docs/repository-strategy.md) |
| Данные | [География и места](../tourism-platform/docs/data-model-geography-places.md), [маршруты](../tourism-platform/docs/data-model-routes.md) |
| Разработка | [Локальный запуск](../tourism-platform/docs/local-development.md), [окружение](../tourism-platform/docs/development-environment.md), [соглашения](../tourism-platform/docs/development-conventions.md) |
| Python | [Стиль](../tourism-platform/docs/python-code-style.md), [тесты](../tourism-platform/docs/python-testing-guide.md) |
| Flutter | [Архитектура](../tourism-platform/docs/flutter-app-architecture.md), [дизайн-система](../tourism-platform/docs/flutter-design-system.md), [стиль](../tourism-platform/docs/flutter-code-style.md), [тесты](../tourism-platform/docs/flutter-testing-guide.md) |

Изменения в дочерних репозиториях сначала проходят review и merge там. Затем
`workspace` обновляет submodule pointers и фиксирует совместимый набор SHA.
Основная площадка разработки — GitLab; GitHub служит публичным зеркалом.
