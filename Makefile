.DEFAULT_GOAL:=help
.DOCKER_COMPOSE := docker-compose
.RUN := $(.DOCKER_COMPOSE) run --rm php

# -- Default -- #
.PHONY: setup destroy start stop restart
setup: buildup dependencies ## Setup the Project
destroy: down-with-volumes ## Destroy the project
start: vendor up ## Start the docker containers
stop: down ## Stop the docker containers
restart: down up ## Restart the docker containers
# -- // Default -- #

# -- Utility -- #
.PHONY: shell
shell: shell-bash ## Start a shell in docker container

.PHONY: dependencies
dependencies: composer-install-ci  ## Install dependencies

# -- // Utility -- #
.PHONY: buildup
buildup:
	# https://github.com/docker/compose/issues/3574
	# if you are working with a remote registry, add this after build:
	# $(.DOCKER_COMPOSE) push php
	$(.DOCKER_COMPOSE) pull && \
	$(.DOCKER_COMPOSE) up -d --build

.PHONY: up
up:
	$(.DOCKER_COMPOSE) up -d

.PHONY: down
down:
	$(.DOCKER_COMPOSE) down

.PHONY: down-with-volumes
down-with-volumes:
	$(.DOCKER_COMPOSE) down --remove-orphans --volumes

.PHONY: shell-bash
shell-bash:
	$(.RUN) bash

vendor: composer.json composer.lock
	$(.RUN) composer install --no-interaction --no-suggest --no-scripts --ansi

# -- CI -- #
composer-install-ci:
	$(.RUN) composer install --no-interaction --no-suggest --no-scripts --ansi
composer-install-production:
	$(.RUN) composer install --no-interaction --no-suggest --no-scripts --ansi --optimize-autoloader --no-dev
# -- // CI -- #

# Based on https://suva.sh/posts/well-documented-makefiles/
help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
