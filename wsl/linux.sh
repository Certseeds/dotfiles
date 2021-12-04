#!/usr/bin/env bash
set -eoux pipefail

cd wsl

sudo ln -s "$(pwd)"/init.wsl /etc/init.wsl
sudo ln -s "$(pwd)"/wsl.conf /etc/wsl.conf

sudo chown -R "${USER}":"${USER}" /etc/init.wsl
sudo chown -R "${USER}":"${USER}" /etc/wsl.conf

cd ./..
