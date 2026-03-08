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
    # run pnpm setup
    # vim the claude code settings.json, to enable allow-dangerous tasks
    # openclaw main using qwen3.5-plus
    # cc using glm-5
}
main
