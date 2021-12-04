#!/usr/bin/env bash
set -eoux pipefail

cd lang

NOW_TIME=$(date --iso-8601=seconds)

folders=("${HOME}/.cargo" "/etc/docker" "${HOME}/.gradle" "${HOME}/.pip" "${HOME}/.m2"
    "${HOME}/.vim/backupdir" "${HOME}/.vim/swapdir" "${HOME}/.vim/undodir")
for item in "${folders[@]}"; do
    echo "${item}"
    mkdir -p "${item}"
done
unset folders

files=("${HOME}/.condarc" "${HOME}/.cargo/config" "/etc/docker/deamon.json"
    "${HOME}/.gradle/init.gradle" "${HOME}/.pip/pip.conf" "${HOME}/.m2/settings.xml"
    "${HOME}/.vimrc" "/etc/nginx/nginx.conf")
for item in "${files[@]}"; do
    echo "${item}"
    if [[ -e "${item}" ]]; then
        mv "${item}" "${item}.${NOW_TIME}.backup"
    else
        echo "${item} Missing"
    fi
done
unset files

sudo ln -s "$(pwd)"/.condarc "${HOME}/.condarc"
sudo ln -s "$(pwd)"/cargo.config.toml "${HOME}/.cargo/config"
sudo ln -s "$(pwd)"/daemon.json "/etc/docker/daemon.json"
sudo ln -s "$(pwd)"/init.gradle "${HOME}/.gradle/init.gradle"
sudo ln -s "$(pwd)"/pip.conf "${HOME}/.pip/pip.conf"
sudo ln -s "$(pwd)"/settings.xml "${HOME}/.m2/settings.xml"
sudo ln -s "$(pwd)"/.vimrc "${HOME}/.vimrc"
sudo cp "$(pwd)"/nginx.conf "/etc/nginx/nginx.conf"

sudo chown -R "${USER}":"${USER}" "${HOME}/.condarc"
sudo chown -R "${USER}":"${USER}" "${HOME}/.cargo/config"
sudo chown -R "${USER}":"${USER}" "/etc/docker/daemon.json"
sudo chown -R "${USER}":"${USER}" "${HOME}/.gradle/init.gradle"
sudo chown -R "${USER}":"${USER}" "${HOME}/.pip/pip.conf"
sudo chown -R "${USER}":"${USER}" "${HOME}/.m2/settings.xml"
sudo chown -R "${USER}":"${USER}" "${HOME}/.vimrc"
sudo chown -R "${USER}":"${USER}" "/etc/nginx/nginx.conf"

unset NOW_TIME

cd ./..
