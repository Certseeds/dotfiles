#!/usr/bin/env bash
set -eoux pipefail

cd wsl

sudo cp "$(pwd)"/etc.wsl.conf /etc/wsl.conf

sudo chown -R "${USER}":"${USER}" /etc/wsl.conf

cd ./..
