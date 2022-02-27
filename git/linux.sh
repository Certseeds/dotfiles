#!/usr/bin/env bash
set -eoux pipefail

cd git

NOW_TIME=$(date --iso-8601=seconds)

mkdir -p "${HOME}"/.ssh

files=("${HOME}/.gitconfig" "${HOME}/.ssh/config")
for item in "${files[@]}"; do
    echo "${item}"
    if [[ -e "${item}" ]]; then
        mv "${item}" "${item}.${NOW_TIME}.backup"
    else
        echo "${item} Missing"
    fi
done
unset files

# cp -p "./gitconfig.template" "./.gitconfig"
# cp -p "./ssh.config.template" "./.ssh.config"

sudo ln -s "$(pwd)"/.gitconfig "${HOME}"/.gitconfig
sudo ln -s "$(pwd)"/.ssh/config "${HOME}"/.ssh/config

sudo chown -R "${USER}":"${USER}" "${HOME}"/.gitconfig
sudo chown -R "${USER}":"${USER}" "${HOME}"/.ssh
sudo chown -R "${USER}":"${USER}" "${HOME}"/.ssh/config

sudo chmod 0755 "${HOME}"/.ssh

unset NOW_TIME

cd ./..
