#!/usr/bin/env bash
# Start the rootless Docker daemon for the current (non-root) user.
#
# Docker CE is already present in the image; this brings up dockerd in
# rootless mode so workspaces can run Docker-in-Docker without privileged
# root. Run it once after the container/workspace starts:
#
#     dockerd-rootless-start
#     docker run --rm hello-world
#
# A DOCKER_HOST from the environment is used if set.
#
# Note: the host must allow user namespaces. In Coder, run the container
# with --userns-host or the equivalent template option.
set -euo pipefail

uid="$(id -u)"
export DOCKER_HOST="${DOCKER_HOST:-unix://${XDG_RUNTIME_DIR:-/run/user/${uid}}/docker.sock}"

if docker info >/dev/null 2>&1; then
    echo "docker daemon already reachable at ${DOCKER_HOST}"
    exit 0
fi

# dockerd-rootless.sh listens on ${XDG_RUNTIME_DIR}/docker.sock. Set the runtime
# dir from DOCKER_HOST so the daemon and the CLI use the same socket.
case "$DOCKER_HOST" in
    unix://*/docker.sock)
        socket="${DOCKER_HOST#unix://}"
        export XDG_RUNTIME_DIR="$(dirname "$socket")"
        ;;
    *)
        echo "no daemon at DOCKER_HOST=${DOCKER_HOST}" >&2
        echo "rootless dockerd needs a unix .../docker.sock path; unset DOCKER_HOST for the default" >&2
        exit 1
        ;;
esac

# /run/user/<uid> lives on tmpfs and is recreated on every container start.
if [ ! -d "$XDG_RUNTIME_DIR" ]; then
    sudo install -d -m 0700 -o "$uid" -g "$(id -g)" "$XDG_RUNTIME_DIR"
fi

echo "starting rootless dockerd ..."
nohup dockerd-rootless.sh >/tmp/dockerd-rootless.log 2>&1 &

for _ in $(seq 1 30); do
    if docker info >/dev/null 2>&1; then
        echo "rootless dockerd ready at ${DOCKER_HOST}"
        exit 0
    fi
    sleep 1
done

echo "dockerd did not become ready in time; see /tmp/dockerd-rootless.log" >&2
exit 1
