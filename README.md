# КРЫМТРИП · Crimea Travel Platform

Мобильное приложение и платформа для планирования поездок по Крыму: каталог мест,
готовые и сгенерированные маршруты, прохождение маршрута с картой и офлайном.

Проект не является официальным государственным приложением и не заявляет об
официальном партнёрстве с государственными организациями.

<!-- MEDIA:HERO -->

<p align="center">
  <img src="docs/media/hero-welcome.jpg" width="220" alt="Экран приветствия" />
  <img src="docs/media/auth-flow.gif" width="220" alt="Регистрация: имя, телефон, код подтверждения" />
</p>

---

## Зачем это нужно

Информация о туристических местах Крыма разбросана и быстро устаревает: режим работы,
сезонные ограничения, состояние троп, где вход и есть ли он вообще. У природных
и горных локаций часто нет ни точного адреса, ни одного входа — их несколько,
и с разных сторон. Плюс в горах пропадает связь ровно тогда, когда маршрут нужнее всего.

Собрать из этого выполнимый маршрут — с учётом того, сколько у тебя времени, едешь ли
ты на машине, есть ли с тобой дети — руками тяжело. КРЫМТРИП делает это за вас
и, что важнее, **показывает, почему предложил именно это**.

## Что умеет

### Каталог и места

Места с категориями, сезонностью, расписанием, несколькими входами и предупреждениями
о безопасности. Данные — PostGIS, поэтому «рядом» — это настоящая география,
а не совпадение по названию.

<!-- MEDIA:CATALOG -->

<p align="center">
  <img src="docs/media/catalog-home.jpg" width="220" alt="Главный экран: топ путешественников и каталог" />
  <img src="docs/media/catalog-deck.jpg" width="220" alt="Свайп-подбор маршрутов" />
</p>

### Три способа получить маршрут

| Способ | Как работает | Кому |
| --- | --- | --- |
| **Готовые маршруты** | Редакционные и пользовательские, прошедшие модерацию | Хочу быстро |
| **Подбор по параметрам** | Форма: город, время, интересы, темп, транспорт → детерминированный скоринг каталога | Знаю, чего хочу |
| **Тревел Агент (ИИ)** | Диалог на русском, уточняющие вопросы, генерация маршрута под ответы | Не знаю, с чего начать |

<!-- MEDIA:MATCH -->

<p align="center">
  <img src="docs/media/match-ai-chat.jpg" width="240" alt="Диалог с Тревел Агентом" />
</p>

### Прохождение маршрута

Пошаговое прохождение с картой, отметкой точек, офлайн-режимом и начислением баллов.
Маршрут фиксируется снапшотом на старте — то есть отчёт о прохождении нельзя
«подкрутить» задним числом, отредактировав маршрут.

<!-- MEDIA:EXECUTION -->

<p align="center">
  <img src="docs/media/execution-progress.jpg" width="240" alt="Прохождение маршрута с картой и прогрессом" />
</p>

### Профиль и социальное

Звания за пройденные маршруты, достижения, статистика, лидерборд, отзывы с фото,
избранное, публикация своих маршрутов с модерацией.

<!-- MEDIA:PROFILE -->

<p align="center">
  <img src="docs/media/profile-overview.jpg" width="220" alt="Профиль: звание и статистика" />
  <img src="docs/media/profile-achievements.jpg" width="220" alt="Список достижений" />
</p>

---

## Чем отличается

**Маршрут объясняет сам себя.** Подбор возвращает не только результат, но и причины:
«старт рядом с Ялтой», «длительность совпадает», «интересы: горы, фото». Пользователь
видит логику, а не чёрный ящик.

**Данные важнее полноты.** Принцип проекта: лучше меньше мест, но с проверенным
расписанием и предупреждениями, чем большой каталог, которому нельзя доверять.
Источник и свежесть критичных данных видны и проверяемы.

**Офлайн там, где он нужен.** Прохождение маршрута переживает пропажу связи —
именно в горах, где она пропадает.

**Сменные провайдеры.** Роутинг, ИИ и геоданные подключены через контракты
(`RoutingProvider`, `AIPlanningProvider`, `TspProvider`, `DistanceMatrixProvider`),
у каждого есть заглушка. Смена поставщика — это конфиг, а не переписывание.
ИИ переключается между локальной моделью и облачной прямо из админки, без редеплоя.

**Не привязан к Крыму.** Модель `Country → Region → Locality → Place` рассчитана
на несколько регионов; Крым — первый контур, а не единственный возможный.

---

## Как устроено

Git superproject с тремя submodule:

```text
workspace/
├── docs/                 # индекс документации
├── tourism-platform/     # docs, Compose, deploy
├── tourism-backend/      # FastAPI modular monolith
└── tourism-mobile/       # Flutter app
```

| Repository | Назначение |
| --- | --- |
| [`tourism-platform`](tourism-platform) | Docs, local Compose, test deploy |
| [`tourism-backend`](tourism-backend) | Python 3.13 / FastAPI modular monolith |
| [`tourism-mobile`](tourism-mobile) | Flutter Android / iOS |

**Мобильное:** Flutter, Riverpod, GoRouter, Dio.
**Бэкенд:** Python 3.13, FastAPI, Pydantic v2, SQLAlchemy 2, Alembic.
**Данные:** PostgreSQL + PostGIS (+ pgvector), Redis.
**Инфраструктура:** Docker Compose, Caddy на тестовом контуре.
**ИИ:** сменный `AIPlanningProvider` — mock / Gemini / LM Studio (Gemma 4 26B).

Модули бэкенда: `identity`, `geography`, `places`, `routes`, `favorites`, `support`,
`notifications`, `admin`, `media`, `route_builder`, `route_execution`, `subscriptions`,
`recommendations`, `knowledge`, `content`, `runtime_config`.

Подробнее: [стек](tourism-platform/docs/stack.md) ·
[доменная модель](tourism-platform/docs/domain-model.md) ·
[архитектурные решения](tourism-platform/docs/decisions)

---

## Статус

Рабочий продукт, не скелет. Каталог, авторизация (OTP/JWT), избранное, публикация
маршрутов, админ-панель, профиль со званиями и лидербордом, отзывы, уведомления
(inbox + FCM), прохождение маршрута, подбор, ИИ-чат — работают. Тестовый контур
задеплоен на отдельный хост.

В работе: улучшение алгоритмов подбора, статьи/блог, переработка RAG.
Живой лог: [progress.md](tourism-platform/docs/progress.md).

---

## Запуск

```bash
git clone --recurse-submodules https://gitlab.com/travel-platform2/workspace.git
cd workspace
make init
make up
```

Для SSH вместо HTTPS:

```bash
git config --global url."git@gitlab.com:".insteadOf "https://gitlab.com/"
```

| Команда | Назначение |
| --- | --- |
| `make init` | Submodules + platform `.env` |
| `make up` / `down` / `ps` / `logs` | Локальная инфраструктура |
| `make validate` | Проверки tourism-platform |
| `make update` | Обновить submodule pointers |
| `make clean CONFIRM=yes` | Удалить volumes |

Бэкенд и мобильное — в своих каталогах:

```bash
cd tourism-backend && uv run tourism-backend      # API
cd tourism-mobile  && flutter run                 # приложение
```

Проверки перед коммитом: `cd tourism-backend && ./scripts/validate.sh`,
`cd tourism-mobile && flutter analyze && flutter test`.

---

## Документация

Канон — в `tourism-platform/docs/`. Индекс: [docs/README.md](docs/README.md).

- [Видение продукта](tourism-platform/docs/product-vision.md)
- [Бизнес-логика](tourism-platform/docs/application-business-logic.md)
- [Доменная модель](tourism-platform/docs/domain-model.md)
- [Стек](tourism-platform/docs/stack.md)
- [Progress — что сделано и что дальше](tourism-platform/docs/progress.md)
- [Архитектурные решения (ADR)](tourism-platform/docs/decisions)
- [Локальная разработка](tourism-platform/docs/local-development.md)
- [Соглашения разработки](tourism-platform/docs/development-conventions.md)

---

## Видимость

Источник истины — GitLab (`gitlab.com/travel-platform2/`), GitHub — публичное зеркало.
