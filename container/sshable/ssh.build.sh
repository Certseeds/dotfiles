#!/usr/bin/env bash
set -euox pipefail
main() {
    if [[ ! -f "sshd_config.conf" ]]; then
        exit 0
    fi
    local SOURCE="ghcr.io"
    local USERNAME="certseeds"
    local IMAGE_NAME="sshable"
    podman build \
        -f "$(pwd)"/container/sshable/ssh.containerfile \
        -t "${SOURCE}"/"${USERNAME}"/"${IMAGE_NAME}" \
        .
}
main
