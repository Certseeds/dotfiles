FROM ubuntu:24.04 as builder

ARG USERNAME="nanoseeds"

LABEL org.opencontainers.image.authors="Certseeds <51754303+Certseeds@users.noreply.github.com>" \
    org.opencontainers.image.source="https://github.com/Certseeds/dotfiles" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.description="一个能在22端口暴露ssh的镜像, 换了源."

EXPOSE 22

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list.d/ubuntu.sources \
  && sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list.d/ubuntu.sources

RUN export DEBIAN_FRONTEND=noninteractive \
  && yes | apt-get update \
  && yes | apt-get upgrade \
  && yes | apt-get install apt-utils openssh-client openssh-server

COPY sshd_config.conf /etc/ssh/sshd_config

RUN echo "root:root" | chpasswd \
  && LANG="zh_SG.UTF-8" \
  && useradd "${USERNAME}" -m -g sudo -s /usr/bin/bash \
  && echo "${USERNAME}:${USERNAME}" | chpasswd \
  && ln -snf /usr/share/zoneinfo/Asia/Singapore /etc/localtime

ENTRYPOINT ["/bin/bash", "-c", "service ssh restart && bash"]

