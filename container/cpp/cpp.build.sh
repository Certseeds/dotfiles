#!/usr/bin/env bash
set -euox pipefail
main() {
    local SOURCE="ghcr.io"
    local USERNAME="certseeds"
    local IMAGE_NAME="cppdev"
    podman build \
        -f "$(pwd)"/container/cpp/cpp.containerfile \
        -t "${SOURCE}"/"${USERNAME}"/"${IMAGE_NAME}" \
        .
}
main
