#!/usr/bin/env bash
set -euox pipefail
main() {
    local SOURCE="ghcr.io"
    local USERNAME="certseeds"
    local IMAGE_NAME="sshable"
    podman build \
        -f "$(pwd)"/container/sshable/ssh.containerfile \
        -t "${SOURCE}"/"${USERNAME}"/"${IMAGE_NAME}" \
        .
}
main
