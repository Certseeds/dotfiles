#!/bin/bash
set -eoux pipefail

cd ubuntu

NOW_TIME=$(date --iso-8601=seconds)

files=("/etc/proxychains4.conf"  "/etc/ssh/ssh_config" "/etc/ssh/sshd_config")
for item in "${files[@]}"; do
    echo "${item}"
    if [[ -e "${item}" ]]; then
        mv "${item}" "${item}.${NOW_TIME}.backup"
    else
        echo "${item} Missing"
    fi
done
unset files

sudo ln -s "$(pwd)"/ssh.config "/etc/ssh/ssh_config"
sudo ln -s "$(pwd)"/sshd_config.conf "/etc/ssh/sshd_config"

sudo chown -R "${USER}":"${USER}" "/etc/ssh/ssh_config"
sudo chown -R "${USER}":"${USER}" "/etc/ssh/sshd_config"

unset NOW_TIME

cd ./..
