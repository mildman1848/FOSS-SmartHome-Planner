.PHONY: help setup env-setup build start stop restart logs status shell test validate lint-docker security-scan clean

IMAGE_NAME ?= mildman1848/foss-smarthome-planner
VERSION := $(shell cat VERSION)
BUILD_DATE := $(shell date -u +'%Y-%m-%dT%H:%M:%SZ')
COMPOSE_FILE ?= docker-compose.yml
SERVICE ?= foss-smarthome-planner

GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
RED := \033[0;31m
NC := \033[0m

## help: Display this help message
help:
	@echo "$(BLUE)FOSS SmartHome Planner$(NC)"
	@echo ""
	@echo "$(GREEN)Available targets:$(NC)"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'

## setup: Create local .env if needed
setup: env-setup
	@echo "$(GREEN)Local setup completed$(NC)"

## env-setup: Create .env from .env.example
env-setup:
	@test ! -f .env && cp .env.example .env || echo "$(YELLOW).env already exists, skipping$(NC)"

## build: Build the local development image
build:
	docker buildx build \
		--platform linux/amd64 \
		--file Dockerfile \
		--tag $(IMAGE_NAME):latest \
		--tag $(IMAGE_NAME):$(VERSION) \
		--build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg VERSION=$(VERSION) \
		--build-arg APP_VERSION=$(VERSION) \
		--load \
		.

## start: Start the development stack
start:
	docker compose -f $(COMPOSE_FILE) up -d $(SERVICE)

## stop: Stop the development stack
stop:
	docker compose -f $(COMPOSE_FILE) down

## restart: Restart the development stack
restart: stop start

## logs: Tail service logs
logs:
	docker compose -f $(COMPOSE_FILE) logs -f $(SERVICE)

## status: Show compose status
status:
	docker compose -f $(COMPOSE_FILE) ps

## shell: Open a shell inside the running container
shell:
	docker compose -f $(COMPOSE_FILE) exec $(SERVICE) /bin/bash

## test: Build image and run a smoke test
test: build
	@echo "$(GREEN)Running smoke test...$(NC)"
	@docker rm -f foss-smarthome-planner-test >/dev/null 2>&1 || true
	@docker run -d --name foss-smarthome-planner-test -p 3900:3000 $(IMAGE_NAME):latest >/dev/null
	@sleep 8
	@curl -fsS http://127.0.0.1:3900/ >/dev/null || (echo "$(RED)Smoke test failed$(NC)" && docker logs foss-smarthome-planner-test && exit 1)
	@docker rm -f foss-smarthome-planner-test >/dev/null
	@echo "$(GREEN)Smoke test passed$(NC)"

## validate: Validate Dockerfile and service scripts
validate: lint-docker
	@echo "$(GREEN)Validating shell scripts...$(NC)"
	@find root -type f \( -name "*.sh" -o -name "run" -o -name "up" \) -print0 | xargs -0 -r -I{} bash -n "{}"
	@echo "$(GREEN)Validation finished$(NC)"

## lint-docker: Run hadolint against the Dockerfile
lint-docker:
	@if ! command -v docker >/dev/null 2>&1; then \
		echo "$(YELLOW)docker not found, skipping hadolint$(NC)"; \
	else \
		docker run --rm -v "$(PWD):/workspace" -w /workspace hadolint/hadolint \
			hadolint --config .hadolint.yaml Dockerfile; \
	fi

## security-scan: Run a Trivy image scan
security-scan: build
	@docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image --severity HIGH,CRITICAL $(IMAGE_NAME):latest

## clean: Remove local build artefacts
clean:
	@docker rm -f foss-smarthome-planner-test >/dev/null 2>&1 || true
	@docker rmi $(IMAGE_NAME):latest $(IMAGE_NAME):$(VERSION) >/dev/null 2>&1 || true
