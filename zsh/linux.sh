#!/bin/bash
###
 # @Author: your name
 # @Date: 2021-07-18 15:00:09
 # @LastEditTime: 2021-07-22 23:13:53
 # @LastEditors: Please set LastEditors
 # @Description: In User Settings Edit
 # @FilePath: \dotfiles-master\zsh\linux.sh
### 
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

cp -p "$(pwd)"/zshrc.template.sh "$(pwd)"/.zshrc
cp -p "$(pwd)"/texlive.template.sh "$(pwd)"/.texlive.sh
cp -p "$(pwd)"/LD_LIBRARY_PATH.template.sh "$(pwd)"/.LD_LIBRARY_PATH.sh

sudo ln -s "$(pwd)"/.zshrc "${HOME}/.zshrc"
sudo ln -s "$(pwd)"/miniconda3.sh "$(pwd)"/.conda.sh

sudo chown -R "${USER}":"${USER}" "${HOME}/.zshrc"
sudo chown -R "${USER}":"${USER}" "$(pwd)"/.conda.sh

unset NOW_TIME

cd ./..
