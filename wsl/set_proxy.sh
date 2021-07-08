#!/bin/bash
set -eoux pipefail
###
 # @Github: https://github.com/Certseeds/tricks
 # @Organization: SUSTech
 # @Author: nanoseeds
 # @Date: 2020-08-21 15:00:50
 # @LastEditors: nanoseeds
 # @LastEditTime: 2020-08-31 12:14:59
### 
# only work for wsl
hostip=$(cat /etc/resolv.conf | grep nameserver | awk '{ print $2 }')
wslip=$(hostname -I | awk '{print $1}')
httpport=4782
sockport=4782

PROXY_HTTP="http://${hostip}:${httpport}"
PROXY_SOCK="http://${hostip}:${sockport}"

set_proxy(){
    sudo sed -i '$d' /etc/proxychains4.conf
    sudo echo "http ${hostip} ${httpport}" >> /etc/proxychains4.conf
}

unset_proxy(){
    unset http_proxy
    unset HTTP_PROXY

    unset https_proxy
    unset HTTPS_PROXY

    #git config --global --unset http.proxy
    #git config --global --unset https.proxy

    unset ALL_PROXY
    unset all_proxy
}

test_setting(){
    echo "Host ip:" ${hostip}
    echo "WSL ip:" ${wslip}
    echo "Current proxy:" ${PROXY_HTTP}
    echo "socks5 proxy": ${PROXY_SOCK}
}
make_history(){
    mv ~/.zsh_history ~/.zsh_history_bad
    touch ~/.zsh_history
}

test_setting
unset_proxy
set_proxy
test_setting
#make_history
