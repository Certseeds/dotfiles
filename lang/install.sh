#!/usr/bin/env bash
set -euox pipefail
main() {
    uv --version
    uvx --version
    uvx dotbot \
        --verbose \
        --base-directory $(dirname "$0") \
        --config install.linux.yaml "$@"
    sudo mkdir -p /etc/docker
    sudo ln -snf "$(pwd)"/daemon.json "/etc/docker/daemon.json"
    sudo chown -R "${USER}":"${USER}" "/etc/docker/daemon.json"
}
main
