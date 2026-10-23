# AGENTS.md

Coder Docker images (fx, php, nodejs, golang, python).

## Writing style

- Write in ASD-STE100 (Simplified Technical English).
- Follow Zinsser's four principles of quality writing:
  1. Simplicity
  2. Brevity
  3. Clarity
  4. Humanity

## Conventions

- Pin every tool version with an `ENV *_VERSION` variable in each Dockerfile.
- Keep Dockerfile comments very short and simple.
- No unparenthesized `|| true` in RUN chains — it can silently skip the rest of the build.
- Smoke tests live in the Makefile (`make test DOCKER_VARIANT=<variant>`).
- `VERSION` holds the release date, `YYYY.MM.DD` (`.N` for a same-day re-release). `make release` bumps it. CI
  tags images `<tag>-<VERSION>` (and `latest` as `<VERSION>`) and creates the GitHub release. See README → *Versions*.
