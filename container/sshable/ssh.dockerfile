FROM ubuntu:jammy as builder

RUN cp /etc/apt/sources.list /tmp/sources.list \
    && sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /tmp/sources.list \
    && sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /tmp/sources.list

FROM ubuntu:jammy

ARG USERNAME="nanoseeds"

LABEL maintainer="Certseeds <51754303+Certseeds@users.noreply.github.com>" \
    org.opencontainers.image.source="https://github.com/Certseeds/dotfiles" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.description="一个能在22端口暴露ssh的镜像, 换了源."

COPY --from=builder /tmp/sources.list /etc/apt/sources.list

EXPOSE 22

RUN yes | apt-get update \
  && yes | apt-get upgrade \
  && yes | apt-get install apt-utils openssh-client openssh-server

COPY sshd_config.conf /etc/ssh/sshd_config

RUN echo "root:root" | chpasswd \
  && LANG="zh_SG.UTF-8" \
  && useradd "${USERNAME}" -m -g sudo -s /usr/bin/bash \
  && echo "${USERNAME}:${USERNAME}" | chpasswd \
  && ln -sf /usr/share/zoneinfo/Asia/Singapore /etc/localtime

ENTRYPOINT ["/bin/bash", "-c", "service ssh restart && bash"]

