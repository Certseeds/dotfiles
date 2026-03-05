#!/usr/bin/env bash
set -euox pipefail
main() {
    local SOURCE="ghcr.io"
    local USERNAME="certseeds"
    local IMAGE_NAME="node"
    podman build \
        -f "$(pwd)"/node/node.containerfile \
        -t "${SOURCE}"/"${USERNAME}"/"${IMAGE_NAME}" \
        --build-arg HTTP_PROXY="" \
        --build-arg HTTPS_PROXY="" \
        .
}
main
