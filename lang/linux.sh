#!/bin/bash
set -eoux pipefail

cd lang

NOW_TIME=$(date --iso-8601=seconds)

folders=("${HOME}/.cargo" "/etc/docker" "${HOME}/.gradle" "${HOME}/.pip" "${HOME}/.m2")
for item in "${folders[@]}"; do
    echo "${item}"
    mkdir -p "${item}"
done
unset folders

files=("${HOME}/.condarc" "${HOME}/.cargo/config" "/etc/docker/deamon.json"
    "${HOME}/.gradle/init.gradle" "${HOME}/.pip/pip.conf" "${HOME}/.m2/settings.xml")
for item in "${files[@]}"; do
    echo "${item}"
    if [[ -f "${item}" ]]; then
        mv "${item}" "${item}.${NOW_TIME}.backup"
    fi
done
unset files

sudo ln -s "$(pwd)"/.condarc "${HOME}/.condarc"
sudo ln -s "$(pwd)"/cargo.config.toml "${HOME}/.cargo/config"
sudo ln -s "$(pwd)"/deamon.json "/etc/docker/deamon.json"
sudo ln -s "$(pwd)"/init.gradle "${HOME}/.gradle/init.gradle"
sudo ln -s "$(pwd)"/pip.conf "${HOME}/.pip/pip.conf"
sudo ln -s "$(pwd)"/settings.xml "${HOME}/.m2/settings.xml"

unset NOW_TIME

cd ./..
