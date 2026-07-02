#!/usr/bin/env bash
set -euox pipefail
main() {
    uv --version
    uvx --version
    sudo uvx dotbot \
        --verbose \
        --base-directory $(dirname "$0") \
        --config install.linux.yaml "$@"
    sudo mkdir -p /etc/systemd/journald.conf.d
}
main
