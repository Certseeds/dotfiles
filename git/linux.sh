#!/bin/bash
set -eoux pipefail

cd git

NOW_TIME=$(date --iso-8601=seconds)

mkdir -p "${HOME}"/.ssh

files=("./.gitconfig" "${HOME}/.gitconfig" "./.ssh.config")
for item in "${files[@]}"; do
    echo "${item}"
    if [[ -f "${item}" ]]; then
        mv "${item}" "${item}.${NOW_TIME}.backup"
    fi
done
unset files

cp "./gitconfig.template" "./.gitconfig"
cp "./ssh.config.template" "./.ssh.config"

sudo ln -s "$(pwd)"/.gitconfig "${HOME}"/.gitconfig
sudo ln -s "$(pwd)"/.ssh.config "${HOME}"/.ssh/config

unset NOW_TIME

cd ./..
