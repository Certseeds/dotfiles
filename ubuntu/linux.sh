#!/bin/bash
set -eoux pipefail

cd ubuntu

NOW_TIME=$(date --iso-8601=seconds)

files=("/etc/proxychains4.conf")
for item in "${files[@]}"; do
    echo "${item}"
    if [[ -f "${item}" ]]; then
        mv "${item}" "${item}.${NOW_TIME}.backup"
    fi
done
unset files

sudo ln -s "$(pwd)"/.condarc "${HOME}/.condarc"

unset NOW_TIME

cd ./..
