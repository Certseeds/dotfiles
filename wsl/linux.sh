#!/bin/bash
set -eoux pipefail

cd wsl

sudo ln -s "$(pwd)"/init.wsl /etc/init.wsl
sudo ln -s "$(pwd)"/wsl.conf /etc/wsl.conf

cd ./..
