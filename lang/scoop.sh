#!/usr/bin/env bash
set -euox pipefail
init() {
    git clone git@ssh.github.com:ScoopInstaller/Main.git \
        ./main \
        --depth=1
    git clone git@ssh.github.com:ScoopInstaller/Java.git \
        ./java \
        --depth=1
    git clone git@ssh.github.com:chawyehsu/dorado.git \
        --depth=1
    git clone git@ssh.github.com:lukesampson/scoop-extras.git \
        ./extras \
        --depth=1
    git clone git@ssh.github.com:matthewjberger/scoop-nerd-fonts.git \
        ./nerd-fonts \
        --depth=1
}
main() {
    local path="$(pwd)"
    for item in $(ls -d -- */); do
        cd "${item}"
        pwd
        git pull \
            --ff-only && echo 'sign no need'
        cd "${path}"
    done
}
main
