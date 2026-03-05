FROM ghcr.io/certseeds/sshable

ENV nvm_version=0.40.1
ARG USERNAME="nanoseeds"
ENV NVM_DIR="/home/${USERNAME}/.nvm"

RUN export DEBIAN_FRONTEND=noninteractive \
  && yes | apt-get update \
  && yes | apt-get upgrade \
  && yes | apt-get install curl

RUN export DEBIAN_FRONTEND=noninteractive \
  && yes | apt-get update \
  && yes | apt-get upgrade \
  && yes | apt-get install sudo git \
  && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
  
USER ${USERNAME}
WORKDIR /home/${USERNAME}

RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v${nvm_version}/install.sh | bash \
  && . "${NVM_DIR}/nvm.sh" \
  && nvm install --lts \
  && nvm use --lts

RUN . "${NVM_DIR}/nvm.sh" \
  && npm config set registry https://registry.npmmirror.com \
  && npm install -g pnpm \
  && pnpm config set registry https://registry.npmmirror.com

ENV SHELL="/bin/bash"

ENTRYPOINT ["/bin/bash"]
