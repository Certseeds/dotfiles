#!/bin/bash
set -eoux pipefail
path=("ubuntu/sources")
for item in "${path[@]}"; do
    ./"${item}"/linux.sh
done

./ubuntu/sources/linux.sh
./git/linux.sh
./lang/linux.sh
./zsh/linux.sh