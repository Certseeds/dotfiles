#!/bin/bash
set -eoux pipefail

cd ubuntu

NOW_TIME=$(date --iso-8601=seconds)

files=("/etc/proxychains4.conf"  "/etc/ssh/ssh_config")
for item in "${files[@]}"; do
    echo "${item}"
    if [[ -f "${item}" ]]; then
        mv "${item}" "${item}.${NOW_TIME}.backup"
    fi
done
unset files

sudo ln -s "$(pwd)"/ssh.config "/etc/ssh/ssh_config"

sudo chown -R "${USER}":"${USER}" "/etc/ssh/ssh_config"

unset NOW_TIME

cd ./..
