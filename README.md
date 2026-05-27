<h1 align=center>Dockette / Coder</h1>

<p align=center>
   Docker images for <a href="https://coder.com">Coder</a> workspaces. Built on Coder’s enterprise base
   and extended with PHP, Node tooling, and a few AI CLIs we use day to day.
</p>

<p align=center>
  <a href="https://github.com/dockette/coder/actions/workflows/docker.yml"><img src="https://github.com/dockette/coder/actions/workflows/docker.yml/badge.svg?branch=master" alt="GitHub Actions"></a>
  <a href="https://hub.docker.com/r/dockette/coder/"><img src="https://badgen.net/docker/pulls/dockette/coder" alt="Docker Hub pulls"></a>
  <a href="https://github.com/sponsors/f3l1x"><img src="https://badgen.net/badge/sponsor/donations/F96854" alt="GitHub Sponsors"></a>
  <a href="https://github.com/orgs/dockette/discussions"><img src="https://badgen.net/badge/help/discussions/blue" alt="Support Discussions"></a>
</p>

-----

## Motivation

`dockette/coder` is meant to drop into a Coder Terraform template so new workspaces already have a sane dev stack.

## Usage

Point your workspace image at this tag (or build from `fx/Dockerfile` if you fork):

```diff
resource "docker_container" "workspace" {
  count = data.coder_workspace.me.start_count
  -image = "codercom/enterprise-base:ubuntu"
  +image = "dockette/coder:fx"
  ...
}
```

## Images

### `dockette/coder:fx`

So you’re replacing the plain enterprise base with the same foundation plus our layers: Node/npm, PHP 8.5, Composer, Deno, Bun, browser automation, and the CLIs listed below.

**Base:** `codercom/enterprise-base:ubuntu` (Ubuntu, `coder` user, usual Coder expectations).

- **Node.js** (includes **npm**) via Nodesource (**Node 22** in this image).
- **Shell:** `mc`, `nano`, `tmux`.
- **PHP 8.5** (Ondrej PPA): CLI + common extensions (curl, intl, mbstring, mysql, pgsql, redis, xml, zip, imagick, etc.).
- **Composer**, **GitHub CLI (`gh`)**.
- **Deno** and **Bun** under `/usr/local`. `/etc/profile` sets `DENO_INSTALL`, `BUN_INSTALL`, and PATH for login shells.
- **Claude** and **OpenCode** installers (best-effort copy to `/usr/local/bin` when present).
- **npm globals:** `@openai/codex`, `@github/copilot`.
- **Chrome libraries** plus **agent-browser** (installs its Chromium).

## Development

```bash
make build
make test
make run
```

## Maintenance

See [how to contribute](https://github.com/dockette/.github/blob/master/CONTRIBUTING.md) to this package. Consider to [support](https://github.com/sponsors/f3l1x) **f3l1x**. Thank you for using this package.
