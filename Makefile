DOCKER_IMAGE=dockette/coder
DOCKER_VARIANT?=fx
DOCKER_TAG?=$(DOCKER_VARIANT)
DOCKER_PLATFORMS?=linux/amd64

TEST_RUN=docker run --rm --platform ${DOCKER_PLATFORMS} ${DOCKER_IMAGE}:${DOCKER_TAG}

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

.PHONY: run
run:
	docker run --rm -it --platform ${DOCKER_PLATFORMS} ${DOCKER_IMAGE}:${DOCKER_TAG}

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
test-fx: DOCKER_TAG=fx
test-fx: _testcase-node _testcase-deno _testcase-bun _testcase-php _testcase-python _testcase-golang _testcase-common

.PHONY: test-php
test-php: DOCKER_TAG=php
test-php: _testcase-php _testcase-common

.PHONY: test-nodejs
test-nodejs: DOCKER_TAG=nodejs
test-nodejs: _testcase-node _testcase-deno _testcase-bun _testcase-common

.PHONY: test-golang
test-golang: DOCKER_TAG=golang
test-golang: _testcase-golang _testcase-common

.PHONY: test-python
test-python: DOCKER_TAG=python
test-python: _testcase-python _testcase-common

.PHONY: _testcase-node
_testcase-node:
	$(TEST_RUN) node --version
	$(TEST_RUN) npm --version
	$(TEST_RUN) node -e "console.log(process.arch)"

.PHONY: _testcase-deno
_testcase-deno:
	$(TEST_RUN) deno --version

.PHONY: _testcase-bun
_testcase-bun:
	$(TEST_RUN) bun --version

.PHONY: _testcase-php
_testcase-php:
	$(TEST_RUN) php --version
	$(TEST_RUN) composer --version

.PHONY: _testcase-python
_testcase-python:
	$(TEST_RUN) python3 --version
	$(TEST_RUN) pip3 --version

.PHONY: _testcase-golang
_testcase-golang:
	$(TEST_RUN) go version

.PHONY: _testcase-common
_testcase-common:
	$(TEST_RUN) agent-browser --version
	$(TEST_RUN) gh --version
	$(TEST_RUN) glab --version
	$(TEST_RUN) claude --version
	$(TEST_RUN) opencode --version
	$(TEST_RUN) codex --version
	$(TEST_RUN) copilot --version
