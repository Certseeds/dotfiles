#!/usr/bin/env bash
set -euox pipefail
main() {
    local SOURCE="ghcr.io"
    local USERNAME="certseeds"
    local IMAGE_NAME="sshable"
    podman run \
        -dit \
        --name "${IMAGE_NAME}" \
        -p 60022:22 \
        "${SOURCE}"/"${USERNAME}":"${IMAGE_NAME}"
}
main
