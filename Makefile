SHELL := /bin/bash

.DEFAULT_GOAL := help

.PHONY: help init update status validate up down restart ps logs clean migrate-gitlab setup-gitlab-group mirror-github \
	backend-sync backend-format backend-lint backend-typecheck backend-test backend-check \
	mobile-get mobile-format mobile-analyze mobile-test mobile-check check

help: ## Показать доступные команды
	@awk 'BEGIN {FS = ":.*## "; printf "Использование: make <command>\n\n"} /^[a-zA-Z_-]+:.*## / {printf "  %-16s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

init: ## Инициализировать submodules и local environment
	@git submodule sync --recursive
	@git submodule update --init --recursive
	@$(MAKE) -C tourism-platform init

update: ## Получить последние commits submodules
	@git submodule sync --recursive
	@git submodule update --init --remote --checkout
	@echo "Проверьте и закоммитьте изменённые submodule pointers."

status: ## Показать состояние superproject и submodules
	@git status --short --branch
	@git submodule status --recursive

validate: ## Проверить superproject и tourism-platform
	@git submodule status --recursive
	@$(MAKE) -C tourism-platform validate

up: ## Запустить local infrastructure
	@$(MAKE) -C tourism-platform up

down: ## Остановить local infrastructure
	@$(MAKE) -C tourism-platform down

restart: ## Перезапустить local infrastructure
	@$(MAKE) -C tourism-platform restart

ps: ## Показать local containers
	@$(MAKE) -C tourism-platform ps

logs: ## Следить за local logs
	@$(MAKE) -C tourism-platform logs

clean: ## Удалить local volumes (требует CONFIRM=yes)
	@$(MAKE) -C tourism-platform clean CONFIRM="$(CONFIRM)"

migrate-gitlab: ## Создать GitLab projects и push всех repositories
	@./scripts/migrate-to-gitlab.sh

setup-gitlab-group: ## Перенести projects в GitLab group travel-platform
	@./scripts/setup-gitlab-group.sh

mirror-github: ## Обновить public showcase mirror на GitHub
	@./scripts/mirror-to-github.sh

backend-sync: ## uv sync backend deps
	@cd tourism-backend && uv sync --all-extras --dev

backend-format: ## Ruff format backend
	@cd tourism-backend && uv run ruff format .

backend-lint: ## Ruff check backend
	@cd tourism-backend && uv run ruff check .

backend-typecheck: ## MyPy backend
	@cd tourism-backend && uv run mypy src/tourism_backend

backend-test: ## Pytest backend
	@cd tourism-backend && uv run pytest

backend-check: ## Full backend validate.sh
	@cd tourism-backend && ./scripts/validate.sh

mobile-get: ## flutter pub get
	@cd tourism-mobile && flutter pub get

mobile-format: ## dart format check
	@cd tourism-mobile && dart format --set-exit-if-changed lib test

mobile-analyze: ## flutter analyze (fatal infos)
	@cd tourism-mobile && flutter analyze --fatal-infos

mobile-test: ## flutter test
	@cd tourism-mobile && flutter test

mobile-check: ## Full mobile validate.sh
	@cd tourism-mobile && ./scripts/validate.sh

check: ## Platform + backend + mobile validates
	@$(MAKE) validate
	@$(MAKE) backend-check
	@$(MAKE) mobile-check
