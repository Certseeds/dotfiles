#!/usr/bin/env bash
set -euox pipefail
main() {
    local SOURCE="ghcr.io"
    local USERNAME="certseeds"
    local IMAGE_NAME="node"
    podman run \
        -dit \
        -e HTTP_PROXY="" \
        -e HTTPS_PROXY="" \
        -e http_proxy="" \
        -e https_proxy="" \
        --name "${IMAGE_NAME}" \
        "${SOURCE}"/"${USERNAME}"/"${IMAGE_NAME}"
}
main
