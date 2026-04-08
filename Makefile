DOCKER_IMAGE=dockette/coder
DOCKER_VARIANT?=fx
DOCKER_TAG?=$(DOCKER_VARIANT)
DOCKER_PLATFORMS?=linux/amd64

# Shared tools present in all images
TOOLS_COMMON=agent-browser gh claude opencode codex copilot

.PHONY: build
build:
	docker buildx build --platform ${DOCKER_PLATFORMS} -t ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_VARIANT}/

.PHONY: build-all
build-all:
	$(MAKE) build DOCKER_VARIANT=fx
	$(MAKE) build DOCKER_VARIANT=php
	$(MAKE) build DOCKER_VARIANT=nodejs
	$(MAKE) build DOCKER_VARIANT=golang
	$(MAKE) build DOCKER_VARIANT=python

.PHONY: test
test:
	$(MAKE) test-${DOCKER_VARIANT}

.PHONY: test-all
test-all:
	$(MAKE) test-fx
	$(MAKE) test-php
	$(MAKE) test-nodejs
	$(MAKE) test-golang
	$(MAKE) test-python

.PHONY: test-fx
test-fx:
	docker run --rm --platform ${DOCKER_PLATFORMS} ${DOCKER_IMAGE}:${DOCKER_TAG} node --version
	docker run --rm --platform ${DOCKER_PLATFORMS} ${DOCKER_IMAGE}:${DOCKER_TAG} npm --version
	docker run --rm --platform ${DOCKER_PLATFORMS} ${DOCKER_IMAGE}:${DOCKER_TAG} node -e "console.log(process.arch)"
	docker run --rm --platform ${DOCKER_PLATFORMS} ${DOCKER_IMAGE}:${DOCKER_TAG} go version
	docker run --rm --platform ${DOCKER_PLATFORMS} ${DOCKER_IMAGE}:${DOCKER_TAG} python3 --version
	docker run --rm --platform ${DOCKER_PLATFORMS} ${DOCKER_IMAGE}:${DOCKER_TAG} pip3 --version
	docker run --rm --platform ${DOCKER_PLATFORMS} ${DOCKER_IMAGE}:${DOCKER_TAG} php --version
	docker run --rm --platform ${DOCKER_PLATFORMS} ${DOCKER_IMAGE}:${DOCKER_TAG} composer --version
	docker run --rm --platform ${DOCKER_PLATFORMS} ${DOCKER_IMAGE}:${DOCKER_TAG} deno --version
	docker run --rm --platform ${DOCKER_PLATFORMS} ${DOCKER_IMAGE}:${DOCKER_TAG} bun --version
	$(foreach tool,$(TOOLS_COMMON),docker run --rm --platform ${DOCKER_PLATFORMS} ${DOCKER_IMAGE}:${DOCKER_TAG} $(tool) --version;)

.PHONY: test-php
test-php:
	docker run --rm --platform ${DOCKER_PLATFORMS} ${DOCKER_IMAGE}:${DOCKER_TAG} php --version
	docker run --rm --platform ${DOCKER_PLATFORMS} ${DOCKER_IMAGE}:${DOCKER_TAG} composer --version
	$(foreach tool,$(TOOLS_COMMON),docker run --rm --platform ${DOCKER_PLATFORMS} ${DOCKER_IMAGE}:${DOCKER_TAG} $(tool) --version;)

.PHONY: test-nodejs
test-nodejs:
	docker run --rm --platform ${DOCKER_PLATFORMS} ${DOCKER_IMAGE}:${DOCKER_TAG} node --version
	docker run --rm --platform ${DOCKER_PLATFORMS} ${DOCKER_IMAGE}:${DOCKER_TAG} npm --version
	docker run --rm --platform ${DOCKER_PLATFORMS} ${DOCKER_IMAGE}:${DOCKER_TAG} node -e "console.log(process.arch)"
	docker run --rm --platform ${DOCKER_PLATFORMS} ${DOCKER_IMAGE}:${DOCKER_TAG} deno --version
	docker run --rm --platform ${DOCKER_PLATFORMS} ${DOCKER_IMAGE}:${DOCKER_TAG} bun --version
	$(foreach tool,$(TOOLS_COMMON),docker run --rm --platform ${DOCKER_PLATFORMS} ${DOCKER_IMAGE}:${DOCKER_TAG} $(tool) --version;)

.PHONY: test-golang
test-golang:
	docker run --rm --platform ${DOCKER_PLATFORMS} ${DOCKER_IMAGE}:${DOCKER_TAG} go version
	$(foreach tool,$(TOOLS_COMMON),docker run --rm --platform ${DOCKER_PLATFORMS} ${DOCKER_IMAGE}:${DOCKER_TAG} $(tool) --version;)

.PHONY: test-python
test-python:
	docker run --rm --platform ${DOCKER_PLATFORMS} ${DOCKER_IMAGE}:${DOCKER_TAG} python3 --version
	docker run --rm --platform ${DOCKER_PLATFORMS} ${DOCKER_IMAGE}:${DOCKER_TAG} pip3 --version
	$(foreach tool,$(TOOLS_COMMON),docker run --rm --platform ${DOCKER_PLATFORMS} ${DOCKER_IMAGE}:${DOCKER_TAG} $(tool) --version;)
