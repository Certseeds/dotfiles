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

cp "$(pwd)"/zshrc.template.sh "$(pwd)"/.zshrc
cp "$(pwd)"/texlive.template.sh "$(pwd)"/.texlive.sh
cp "$(pwd)"/LD_LIBRARY_PATH.template.sh "$(pwd)"/.LD_LIBRARY_PATH.sh

sudo ln -s "$(pwd)"/.zshrc "${HOME}/.zshrc"
sudo ln -s "$(pwd)"/miniconda3.sh "$(pwd)"/conda.sh 

unset NOW_TIME

cd ./..
