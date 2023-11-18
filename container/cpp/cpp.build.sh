#!/usr/bin/env bash
set -euox pipefail
main() {
    local SOURCE="ghcr.io"
    local USERNAME="certseeds"
    local IMAGE_NAME="cppdev"
    podman build \
        -f "$(pwd)"/cpp.dockerfile \
        -t "${SOURCE}"/"${USERNAME}"/"${IMAGE_NAME}" \
        .
}
main
