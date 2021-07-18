#!/bin/bash
set -eoux pipefail

cd wsl

sudo ln -s "$(pwd)"/init.wsl /etc/init.wsl

cd ./..
