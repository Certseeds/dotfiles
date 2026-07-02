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
deftime() {
    ln -snf /usr/share/zoneinfo/GMT /etc/localtime
    echo "Europe/London" | sudo tee /etc/timezone >/dev/null
}
deftime

