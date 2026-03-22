<h1 align=center>Dockette / Coder</h1>

<p align=center>
   Docker images for <a href="https://coder.com">Coder</a> workspaces. Built on Coder’s enterprise base
   and extended with PHP, Node tooling, and a few AI CLIs we use day to day.
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
```

-----

Consider supporting [f3l1x on GitHub Sponsors](https://github.com/sponsors/f3l1x) if you rely on this. Thanks for using it.
