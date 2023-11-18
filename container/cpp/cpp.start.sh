#!/usr/bin/env bash
set -euox pipefail
main() {
    local SOURCE="ghcr.io"
    local USERNAME="certseeds"
    local IMAGE_NAME="cppdev"
    podman run \
        -dit \
        --name "${IMAGE_NAME}" \
        -p 60023:22 \
        "${SOURCE}"/"${USERNAME}"/"${IMAGE_NAME}"
}
main
