#!/bin/bash
set -eoux pipefail

cd zsh

NOW_TIME=$(date --iso-8601=seconds)

files=("${HOME}/.zshrc")

for item in "${files[@]}"; do
    echo "${item}"
    if [[ -f "${item}" ]]; then
        mv "${item}" "${item}.${NOW_TIME}.backup"
    fi
done
unset files

cp "$(pwd)"/zshrc.template "$(pwd)"/.zshrc

sudo ln -s "$(pwd)"/.zshrc "${HOME}/.zshrc"

unset NOW_TIME

cd ./..
