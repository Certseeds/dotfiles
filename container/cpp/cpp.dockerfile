FROM ghcr.io/certseeds/sshable

LABEL maintainer="Certseeds <51754303+Certseeds@users.noreply.github.com>" \
    org.opencontainers.image.source="https://github.com/Certseeds/dotfiles" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.description="cpp dev image that can ssh"

RUN yes | apt-get update \
  && yes | apt-get upgrade \
  && yes | apt-get install build-essential \
  && yes | apt-get install cmake \
  && yes | apt-get install gdb \
  && yes | apt-get install make \
  && yes | apt-get install ccache

