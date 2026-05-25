FROM ubuntu:26.04

ENV USERNAME="nanoseeds"

EXPOSE 22

ENV TZ='UTC' \
    LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list.d/ubuntu.sources \
  && sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list.d/ubuntu.sources

RUN export DEBIAN_FRONTEND=noninteractive \
  && yes | apt-get update \
  && yes | apt-get upgrade \
  && yes | apt-get install apt-utils openssh-client openssh-server locales \
      --no-install-recommends \
  && yes | apt-get install wget curl \
      --no-install-recommends \
  && yes | apt-get install ca-certificates \
      --no-install-recommends \
  && rm -rf /var/lib/apt/lists/* \
  && locale-gen zh_CN.UTF-8

COPY ./container/sshable/sshd_config.conf /etc/ssh/sshd_config

RUN echo "root:root" | chpasswd \
  && useradd "${USERNAME}" -m -g sudo -s /usr/bin/bash \
  && echo "${USERNAME}:${USERNAME}" | chpasswd \
  && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ENTRYPOINT ["/bin/bash", "-c", "service ssh restart && bash"]
