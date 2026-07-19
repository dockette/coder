<h1 align=center>Dockette / Coder</h1>

<p align=center>
   Docker images for <a href="https://coder.com">Coder</a> workspaces. Built on Coder’s enterprise base
   and extended with language runtimes, developer tooling, and the AI CLIs we use day to day.
</p>

<p align=center>
   <a href="https://github.com/dockette/coder/actions"><img src="https://github.com/dockette/coder/actions/workflows/docker.yml/badge.svg" alt="GitHub Actions"></a>
   <a href="https://hub.docker.com/r/dockette/coder"><img src="https://img.shields.io/docker/pulls/dockette/coder.svg" alt="Docker Hub pulls"></a>
   <a href="https://github.com/sponsors/f3l1x"><img src="https://img.shields.io/badge/sponsor-GitHub%20Sponsors-ea4aaa" alt="GitHub Sponsors"></a>
   <a href="https://github.com/orgs/dockette/discussions"><img src="https://img.shields.io/badge/support-discussions-6f42c1" alt="Support/Discussions"></a>
</p>

-----

## Motivation

`dockette/coder` is meant to drop into a [Coder](https://coder.com) Terraform template so new
workspaces come up with a sane dev stack already in place — no per-workspace provisioning scripts.

Every image builds on `codercom/enterprise-base:ubuntu` (Ubuntu, `coder` user, the usual Coder
expectations) and adds a shared baseline of developer and AI tooling. On top of that baseline, each
tag targets a specific stack: an all-in-one image (`fx`) plus focused, lighter images for PHP,
Node.js, Go, and Python.

## Images

All images are published to Docker Hub as [`dockette/coder`](https://hub.docker.com/r/dockette/coder),
one tag per template:

| Tag                    | Focus              | Node.js | pnpm | Deno / Bun | PHP 8.5 + Composer | Python 3 | Go   | Rootless Docker |
| ---------------------- | ------------------ | :-----: | :--: | :--------: | :----------------: | :------: | :--: | :-------------: |
| **`fx`**               | Everything         |   ✅    |  ✅  |     ✅     |         ✅         |    ✅    |  ✅  |       ✅        |
| **`php`**              | PHP                |   ✅    |      |            |         ✅         |          |      |                 |
| **`nodejs`**           | JavaScript runtime |   ✅    |      |     ✅     |                    |          |      |                 |
| **`golang`**           | Go                 |   ✅    |      |            |                    |          |  ✅  |                 |
| **`python`**           | Python             |   ✅    |      |            |                    |    ✅    |      |                 |

> Node.js (with `npm`) ships in every image because the shared AI CLIs are installed from npm.
> The `nodejs` tag additionally provides Deno and Bun; only the `fx` tag adds `pnpm`.

### Shared baseline

Every image includes:

- **Base tooling:** `git`, `jq`, `ripgrep`.
- **Node.js 24** with `npm` (via NodeSource).
- **VCS CLIs:** GitHub CLI (`gh`) and GitLab CLI (`glab`).
- **AI CLIs:** `claude` (Claude Code), `opencode`, `codex` (`@openai/codex`), and `copilot` (`@github/copilot`).
- **Browser automation:** `agent-browser` plus the Chrome shared libraries it needs (Chromium is
  installed on first `agent-browser install`).

The AI CLIs are installed into a location that survives Coder’s persistent `/home/coder` volume,
so they remain available after the home directory is mounted over at runtime.

### `dockette/coder:fx`

The all-in-one image — the shared baseline plus every language runtime and Docker-in-Docker.
Choose this when a workspace is polyglot or you don’t want to commit to one stack.

- **Node.js 24** (`npm`, `pnpm`), **Deno**, and **Bun** (Deno/Bun under `/usr/local`, with PATH set for login shells).
- **PHP 8.5** (Ondřej PPA): CLI plus common extensions (`curl`, `intl`, `mbstring`, `mysql`, `pgsql`,
  `redis`, `xml`, `zip`, `imagick`, `bcmath`, `apcu`, `gmp`, `ldap`, `amqp`, `memcached`, `soap`,
  `xsl`, `yaml`, …) and both coverage drivers (`xdebug`, `pcov`).
- **Composer**.
- **Python 3** with `pip` and `venv`.
- **Go 1.26.5** (installed to `/usr/local/go`; `GOROOT`/`GOPATH`/PATH set for login shells).
- **Rootless Docker** (docker-in-docker) — see [Rootless Docker](#rootless-docker) below.

### `dockette/coder:php`

PHP-focused image for backend and web projects.

- **PHP 8.5** (Ondřej PPA): CLI plus the same extension set as `fx`, including `xdebug` and `pcov`.
- **Composer**.
- **Node.js 24** with `npm` (for asset builds and the shared AI CLIs).

### `dockette/coder:nodejs`

JavaScript/TypeScript image with multiple runtimes.

- **Node.js 24** with `npm`.
- **Deno** and **Bun** (installed under `/usr/local`, with PATH set for login shells).

### `dockette/coder:golang`

Go-focused image.

- **Go 1.26.5** (installed to `/usr/local/go`; `GOROOT`/`GOPATH`/PATH set for login shells).
- **Node.js 24** with `npm` (for the shared AI CLIs).

### `dockette/coder:python`

Python-focused image.

- **Python 3** with `pip` and `venv`.
- **Node.js 24** with `npm` (for the shared AI CLIs).

## Usage

Point your Coder workspace image at the tag that fits your stack (or build from the matching
`<template>/Dockerfile` if you fork):

```diff
resource "docker_container" "workspace" {
  count = data.coder_workspace.me.start_count
- image = "codercom/enterprise-base:ubuntu"
+ image = "dockette/coder:fx"
  ...
}
```

Swap `fx` for `php`, `nodejs`, `golang`, or `python` to use a lighter, stack-specific image.

## Rootless Docker

The `fx` image can run Docker-in-Docker without privileged root. Start the daemon inside the workspace:

```bash
dockerd-rootless-start
docker run --rm hello-world
```

`DOCKER_HOST` and `XDG_RUNTIME_DIR` are preset for login shells, so the CLI talks to the rootless
daemon automatically. The host must permit nested user namespaces — in a Coder Terraform template,
run the workspace container with `privileged = true` (or the equivalent `--userns` setup), and call
`dockerd-rootless-start` from `startup_script` so Docker is ready on boot.

## Development

Images are built and tested per template with the provided `Makefile`. `DOCKER_VARIANT` selects the
template (default `fx`):

```bash
# Build and test a single template
make build DOCKER_VARIANT=nodejs
make test  DOCKER_VARIANT=nodejs
make run   DOCKER_VARIANT=nodejs

# Build and test every template
make build-all
make test-all
```

Each template is smoke-tested in CI (build, then version checks for its runtimes and the shared
CLIs) and, on `master`, built and pushed to Docker Hub across all five tags.

## Maintenance

See [how to contribute](https://github.com/dockette/.github/blob/master/CONTRIBUTING.md) to this package. Consider to [support](https://github.com/sponsors/f3l1x) **f3l1x**. Thank you for using this package.
