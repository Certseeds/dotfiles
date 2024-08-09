#!/usr/bin/env bash
set -eoux pipefail

cd zsh

NOW_TIME=$(date --iso-8601=seconds)

files=("${HOME}/.zshrc")

for item in "${files[@]}"; do
    echo "${item}"
    if [[ -e "${item}" ]]; then
        mv "${item}" "${item}.${NOW_TIME}.backup"
    fi
done
unset files

# cp -p "$(pwd)"/zshrc.template.sh "$(pwd)"/.zshrc
# cp -p "$(pwd)"/texlive.template.sh "$(pwd)"/.texlive.sh
# cp -p "$(pwd)"/LD_LIBRARY_PATH.template.sh "$(pwd)"/.LD_LIBRARY_PATH.sh

sudo ln -s "$(pwd)"/.zshrc "${HOME}/.zshrc"
sudo ln -s "$(pwd)"/miniconda3.sh "$(pwd)"/.conda.sh

sudo chown -R "${USER}":"${USER}" "${HOME}/.zshrc"
sudo chown -R "${USER}":"${USER}" "$(pwd)"/.conda.sh

unset NOW_TIME
ln -snf /usr/share/zoneinfo/GMT /etc/localtime
echo "Europe/London" | sudo tee /etc/timezone > /dev/null

cd ./..

function install(){
    sudo apt install -y zsh
    sudo chsh -s "$(which zsh)"
    sudo usermod -s "$(which zsh)" "$(whoami)"
    if [ -d "${HOME}/.oh-my-zsh" ]; then
        rm -rf "${HOME}/.oh-my-zsh"
    fi
    proxychains4 git clone https://github.com/ohmyzsh/ohmyzsh.git \
        "${HOME}"/.oh-my-zsh --depth=1
    proxychains4 git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        "${HOME}"/.oh-my-zsh/plugins/zsh-syntax-highlighting --depth=1
    proxychains4 git clone https://github.com/zsh-users/zsh-autosuggestions.git \
        "${HOME}"/.oh-my-zsh/plugins/zsh-autosuggestions --depth=1
    {
        sudo chmod 0755 "${HOME}"/.oh-my-zsh
        sudo chmod 0755 "${HOME}"/.oh-my-zsh/custom/plugins
        sudo chmod 0755 "${HOME}"/.oh-my-zsh/plugins
        sudo chmod 0755 "${HOME}"/.oh-my-zsh/plugins/z
        sudo chmod 0755 "${HOME}"/.oh-my-zsh/plugins/git
        sudo chmod 0755 "${HOME}"/.oh-my-zsh/plugins/zsh-syntax-highlighting
        sudo chmod 0755 "${HOME}"/.oh-my-zsh/plugins/zsh-autosuggestions
    }
}
