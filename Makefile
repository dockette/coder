DOCKER_IMAGE=dockette/coder
DOCKER_TAG?=fx
DOCKER_PLATFORMS?=linux/amd64,linux/arm64

build:
	docker buildx build --platform ${DOCKER_PLATFORMS} -t ${DOCKER_IMAGE}:${DOCKER_TAG} fx/

test:
	docker run --rm ${DOCKER_IMAGE}:${DOCKER_TAG} node --version
	docker run --rm ${DOCKER_IMAGE}:${DOCKER_TAG} php --version
	docker run --rm ${DOCKER_IMAGE}:${DOCKER_TAG} composer --version
	docker run --rm ${DOCKER_IMAGE}:${DOCKER_TAG} deno --version
	docker run --rm ${DOCKER_IMAGE}:${DOCKER_TAG} bun --version
	docker run --rm ${DOCKER_IMAGE}:${DOCKER_TAG} gh --version
	docker run --rm ${DOCKER_IMAGE}:${DOCKER_TAG} claude --version
	docker run --rm ${DOCKER_IMAGE}:${DOCKER_TAG} cursor-agent --version
	docker run --rm ${DOCKER_IMAGE}:${DOCKER_TAG} opencode --version
	docker run --rm ${DOCKER_IMAGE}:${DOCKER_TAG} codex --version
	docker run --rm ${DOCKER_IMAGE}:${DOCKER_TAG} copilot --version
