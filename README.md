<h1 align=center>Dockette / Coder</h1>

<p align=center>
   Docker base images for <a href="https://coder.com">Coder</a> workspaces. Extends the official Coder Node image with PHP, Composer, Deno, Bun, GitHub CLI, and dev tooling.
</p>

<p align=center>
  <a href="https://hub.docker.com/r/dockette/coder/"><img src="https://badgen.net/docker/pulls/dockette/coder"></a>
  <a href="https://bit.ly/ctteg"><img src="https://badgen.net/badge/support/gitter/cyan"></a>
  <a href="https://github.com/sponsors/f3l1x"><img src="https://badgen.net/badge/sponsor/donations/F96854"></a>
</p>

-----

## Usage

```
docker run -it dockette/coder:fx
```

**Base image**

```Dockerfile
FROM dockette/coder:fx

USER root
# optional extra layers
USER coder
```

## Documentation

### From base (codercom/example-node:ubuntu)

Ubuntu Noble, Node.js LTS, Yarn, Docker, git, curl, htop, jq, vim, wget, sudo, `coder` user.

### Added in fx

mc, nano, PHP 8.5 (cli, curl, intl, mbstring, readline, xml, zip), Composer, GitHub CLI (gh), Deno, Bun, Claude CLI, OpenCode, and npm globals: vibe-kanban, @openai/codex, @github/copilot.

### Coder template

Use this image in your Terraform template so workspaces start with all tools preinstalled: set `docker_image` / `docker_container` to `dockette/coder:fx`, or use a Dockerfile that starts with `FROM dockette/coder:fx`. Your `startup_script` can be reduced to first-run init (e.g. copy `/etc/skel` into home, touch `~/.init_done`); no need to install packages or run install scripts.

### PATH

Deno and Bun are installed under `/usr/local`. Their env and `bin` dirs are appended to `/etc/profile` so all login shells get `DENO_INSTALL`, `BUN_INSTALL`, and PATH.

## Development

See [how to contribute](https://contributte.org/contributing.html) to this package.

-----

Consider to [support](https://github.com/sponsors/f3l1x) **f3l1x**. Also thank you for using this package.
