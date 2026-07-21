SHELL := /bin/bash

.DEFAULT_GOAL := help

.PHONY: help init update status validate up down restart ps logs clean

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
