#!/usr/bin/env bash
set -eoux pipefail

ID="$(lsb_release -i | sed 's/Distributor ID://g' | xargs)"
if [[ "${ID}" != "Ubuntu" ]]; then
    echo "Only support Ubuntu"
    unset ID
    exit
else
    unset ID
fi

UBUNTU_VERSION="$(lsb_release -c | sed 's/Codename://g' | xargs)"
UBUNTU1804="bionic"
UBUNTU2004="focal"
NOW_TIME=$(date --iso-8601=seconds)
SUBPATH="ubuntu/sources"

if [[ -e "/etc/apt/sources.list" ]]; then
    mv "/etc/apt/sources.list" "/etc/apt/sources.list.${NOW_TIME}.backup"
fi
cd "${SUBPATH}"
if [[ "${UBUNTU_VERSION}" == "${UBUNTU1804}" ]]; then
    cp -p "sources_aliyun_1804.list.backup" "/etc/apt/sources.list"
elif [[ "${UBUNTU_VERSION}" == "${UBUNTU2004}" ]]; then
    cp -p "sources_aliyun_2004.list.backup" "/etc/apt/sources.list"
fi
cd ./../../

unset SUBPATH
unset UBUNTU_VERSION
unset UBUNTU1804
unset UBUNTU2004
unset NOW_TIME
