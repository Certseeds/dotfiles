#!/usr/bin/env bash
set -eoux pipefail
path=("ubuntu/sources" "git" "lang" "zsh" "wsl")
for item in "${path[@]}"; do
    ./"${item}"/linux.sh
done

#./ubuntu/sources/linux.sh