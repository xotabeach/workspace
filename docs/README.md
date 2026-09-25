# Документация workspace

`workspace` фиксирует совместимые версии четырёх submodules. Общая продуктовая и
архитектурная документация находится в `tourism-platform/docs/`; здесь —
публичный индекс документов, которые входят в Git.

| Тема | Документы |
| --- | --- |
| Текущие возможности | [Статус](https://github.com/xotabeach/tourism-platform/blob/main/docs/current-status.md), [README backend](https://github.com/xotabeach/tourism-backend/blob/main/README.md), [README mobile](https://github.com/xotabeach/tourism-mobile/blob/main/README.md), [README landing](https://github.com/xotabeach/tourism-landing/blob/main/README.md) |
| Продукт и домен | [Видение](https://github.com/xotabeach/tourism-platform/blob/main/docs/product-vision.md), [бизнес-логика](https://github.com/xotabeach/tourism-platform/blob/main/docs/application-business-logic.md), [доменная модель](https://github.com/xotabeach/tourism-platform/blob/main/docs/domain-model.md) |
| Архитектура | [Системный контекст](https://github.com/xotabeach/tourism-platform/blob/main/docs/system-context.md), [стек](https://github.com/xotabeach/tourism-platform/blob/main/docs/stack.md), [ADR](https://github.com/xotabeach/tourism-platform/blob/main/docs/decisions), [стратегия репозиториев](https://github.com/xotabeach/tourism-platform/blob/main/docs/repository-strategy.md) |
| Данные | [География и места](https://github.com/xotabeach/tourism-platform/blob/main/docs/data-model-geography-places.md), [маршруты](https://github.com/xotabeach/tourism-platform/blob/main/docs/data-model-routes.md) |
| Разработка | [Локальный запуск](https://github.com/xotabeach/tourism-platform/blob/main/docs/local-development.md), [окружение](https://github.com/xotabeach/tourism-platform/blob/main/docs/development-environment.md), [соглашения](https://github.com/xotabeach/tourism-platform/blob/main/docs/development-conventions.md) |
| Python | [Стиль](https://github.com/xotabeach/tourism-platform/blob/main/docs/python-code-style.md), [тесты](https://github.com/xotabeach/tourism-platform/blob/main/docs/python-testing-guide.md) |
| Flutter | [Архитектура](https://github.com/xotabeach/tourism-platform/blob/main/docs/flutter-app-architecture.md), [дизайн-система](https://github.com/xotabeach/tourism-platform/blob/main/docs/flutter-design-system.md), [стиль](https://github.com/xotabeach/tourism-platform/blob/main/docs/flutter-code-style.md), [тесты](https://github.com/xotabeach/tourism-platform/blob/main/docs/flutter-testing-guide.md) |

Изменения в дочерних репозиториях сначала проходят review и merge там. Затем
`workspace` обновляет submodule pointers и фиксирует совместимый набор SHA.
Основная площадка разработки — GitLab; GitHub служит публичным зеркалом.
