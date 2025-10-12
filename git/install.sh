#!/usr/bin/env bash
set -euox pipefail
main() {
    uv --version
    uvx --version
    uvx dotbot \
        --verbose \
        --base-directory $(dirname "$0") \
        --config install.conf.yaml "$@"
}
main
