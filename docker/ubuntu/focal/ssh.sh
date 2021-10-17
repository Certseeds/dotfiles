#!/usr/bin/env bash
set -euox pipefail
zsh_download() {
    local PWD_PATH="${HOME}/dotfiles/docker/ubuntu/focal"
    rm -rf "${PWD_PATH}/.oh-my-zsh"
    cp -r "${HOME}/.oh-my-zsh" "${PWD_PATH}/.oh-my-zsh"
}
main() {
    zsh_download
    local DOTFILES_PATH="${HOME}/dotfiles"
    local UBUNTU_VERSION="focal"
    local USERNAME="nanoseeds"
    local USER_AGENT="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:86.1) Gecko/20100101 Firefox/86.1"
    local ETC_APT_SOURCES_LIST=$(cat ${DOTFILES_PATH}/ubuntu/sources/sources_163_2004.list.backup)
    local ETC_SSH_SSHD_CONFIG=$(cat ${DOTFILES_PATH}/docker/sshd_config.conf)
    local HOME_DOTFILES_GITCONFIG=$(cat ${DOTFILES_PATH}/git/gitconfig.template)
    local HOME_DOTFILES_GITCOMMIT=$(cat ${DOTFILES_PATH}/git/gitcommit)
    local HOME_DOTFILES_CONDARC=$(cat ${DOTFILES_PATH}/lang/.condarc)
    local HOME_DOTFILES_VIMRC=$(cat ${DOTFILES_PATH}/lang/vimrc.template)
    local HOME_DOTFILES_CARGO_CONFIG=$(cat ${DOTFILES_PATH}/lang/cargo.config.toml)
    local HOME_DOTFILES_GRADLE=$(cat ${DOTFILES_PATH}/lang/init.gradle)
    local HOME_DOTFILES_PIP_CONF=$(cat ${DOTFILES_PATH}/lang/pip.conf)
    local HOME_DOTFILES_M2_SETTINGS=$(cat ${DOTFILES_PATH}/lang/settings.xml)
    local HOME_DOTFILES_ZSHRC=$(cat ${DOTFILES_PATH}/zsh/zshrc.template.sh)
    local HOME_DOTFILES_ZSH_MINICONDA3=$(cat ${DOTFILES_PATH}/zsh/miniconda3.sh)
    docker build -f "${DOTFILES_PATH}"/docker/ubuntu/focal/ssh.Dockerfile \
        --build-arg ETC_APT_SOURCES_LIST="${ETC_APT_SOURCES_LIST}" \
        --build-arg ETC_SSH_SSHD_CONFIG="${ETC_SSH_SSHD_CONFIG}" \
        --build-arg HOME_DOTFILES_GITCONFIG="${HOME_DOTFILES_GITCONFIG}" \
        --build-arg HOME_DOTFILES_GITCOMMIT="${HOME_DOTFILES_GITCOMMIT}" \
        --build-arg HOME_DOTFILES_CONDARC="${HOME_DOTFILES_CONDARC}" \
        --build-arg HOME_DOTFILES_VIMRC="${HOME_DOTFILES_VIMRC}" \
        --build-arg HOME_DOTFILES_CARGO_CONFIG="${HOME_DOTFILES_CARGO_CONFIG}" \
        --build-arg HOME_DOTFILES_GRADLE="${HOME_DOTFILES_GRADLE}" \
        --build-arg HOME_DOTFILES_PIP_CONF="${HOME_DOTFILES_PIP_CONF}" \
        --build-arg HOME_DOTFILES_M2_SETTINGS="${HOME_DOTFILES_M2_SETTINGS}" \
        --build-arg HOME_DOTFILES_ZSH_MINICONDA3="${HOME_DOTFILES_ZSH_MINICONDA3}" \
        --build-arg HOME_DOTFILES_ZSHRC="${HOME_DOTFILES_ZSHRC}" \
        -t ${USERNAME}:${UBUNTU_VERSION} .
}
main
