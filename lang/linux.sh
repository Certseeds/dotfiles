#!/usr/bin/env bash
set -eoux pipefail

cd lang

NOW_TIME=$(date --iso-8601=seconds)

folders=("${HOME}/.cargo" "/etc/docker" "${HOME}/.gradle" "${HOME}/.pip" "${HOME}/.m2"
    "${HOME}/.vim/backupdir" "${HOME}/.vim/swapdir" "${HOME}/.vim/undodir" "${HOME}/.gnupg"
    "${HOME}/.config/pypoetry" "${HOME}/.config/pdm"
    )
for item in "${folders[@]}"; do
    echo "${item}"
    mkdir -p "${item}"
done
unset folders

files=("${HOME}/.condarc" "${HOME}/.cargo/config" "/etc/docker/deamon.json"
    "${HOME}/.gradle/init.gradle" "${HOME}/.pip/pip.conf" "${HOME}/.m2/settings.xml"
    "${HOME}/.vimrc" "/etc/nginx/nginx.conf" "${HOME}/.gnupg/gpg.conf"
    "${HOME}/.gnupg/gpg-agent.conf" "${HOME}/.config/pypoetry/config.toml"
    "${HOME}/.config/pdm/config.toml"
    )
for item in "${files[@]}"; do
    echo "${item}"
    if [[ -e "${item}" ]]; then
        mv "${item}" "${item}.${NOW_TIME}.backup"
    else
        echo "${item} Missing"
    fi
done
unset files

sudo ln -snf "$(pwd)"/.condarc "${HOME}/.condarc"
sudo ln -snf "$(pwd)"/cargo.config.toml "${HOME}/.cargo/config"
sudo ln -snf "$(pwd)"/daemon.json "/etc/docker/daemon.json"
sudo ln -snf "$(pwd)"/init.gradle "${HOME}/.gradle/init.gradle"
sudo ln -snf "$(pwd)"/pip.conf "${HOME}/.pip/pip.conf"
sudo ln -snf "$(pwd)"/settings.xml "${HOME}/.m2/settings.xml"
sudo ln -snf "$(pwd)"/.vimrc "${HOME}/.vimrc"
sudo ln -snf "$(pwd)"/gpg.conf "${HOME}/.gnupg/gpg.conf"
sudo ln -snf "$(pwd)"/gpg.agent.conf "${HOME}/.gnupg/gpg-agent.conf"
sudo ln -snf "$(pwd)"/poetry.config.toml "${HOME}/.config/pypoetry/config.toml"
sudo ln -snf "$(pwd)"/pdm.config.toml "${HOME}/.config/pdm/config.toml"
# sudo cp "$(pwd)"/nginx.conf "/etc/nginx/nginx.conf"

sudo chown -R "${USER}":"${USER}" "${HOME}/.condarc"
sudo chown -R "${USER}":"${USER}" "${HOME}/.cargo/config"
sudo chown -R "${USER}":"${USER}" "/etc/docker/daemon.json"
sudo chown -R "${USER}":"${USER}" "${HOME}/.gradle/init.gradle"
sudo chown -R "${USER}":"${USER}" "${HOME}/.pip/pip.conf"
sudo chown -R "${USER}":"${USER}" "${HOME}/.m2/settings.xml"
sudo chown -R "${USER}":"${USER}" "${HOME}/.vimrc"
sudo chown -R "${USER}":"${USER}" "${HOME}/.gnupg/gpg.conf"
sudo chown -R "${USER}":"${USER}" "${HOME}/.gnupg/gpg-agent.conf"
sudo chown -R "${USER}":"${USER}" "${HOME}/.config/pypoetry/config.toml"
sudo chown -R "${USER}":"${USER}" "${HOME}/.config/pdm/config.toml"
# sudo chown -R "${USER}":"${USER}" "/etc/nginx/nginx.conf"

unset NOW_TIME

cd ./..
