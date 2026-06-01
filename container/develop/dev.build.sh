#!/usr/bin/env bash
set -euox pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

main() {
    local SOURCE="ghcr.io"
    local USERNAME="certseeds"
    local IMAGE_NAME="develop"

    source "${SCRIPT_DIR}/python.version"
    source "${SCRIPT_DIR}/nodejs-lts.version"
    source "${SCRIPT_DIR}/pnpm.version"
    source "${SCRIPT_DIR}/jdk-lts.version"
    source "${SCRIPT_DIR}/maven.version"

    podman build \
        -f "${SCRIPT_DIR}/dev.containerfile" \
        -t "${SOURCE}/${USERNAME}/${IMAGE_NAME}" \
        --jobs 0 \
        --pull=never \
        --build-arg HTTP_PROXY="" \
        --build-arg HTTPS_PROXY="" \
        --build-arg PYTHON_BUILD_DATE="${PYTHON_BUILD_DATE}" \
        --build-arg PYTHON_VERSION="${PYTHON_VERSION}" \
        --build-arg PYTHON_BINARY_TYPE="${PYTHON_BINARY_TYPE}" \
        --build-arg NODE_VERSION="${NODE_VERSION}" \
        --build-arg PNPM_VERSION="${PNPM_VERSION}" \
        --build-arg JDK_MAJOR="${JDK_MAJOR}" \
        --build-arg JDK_VERSION="${JDK_VERSION}" \
        --build-arg MAVEN_VERSION="${MAVEN_VERSION}" \
        .

}

main
