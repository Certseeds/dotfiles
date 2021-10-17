FROM ubuntu:focal

LABEL maintainer="Certseeds <51754303+Certseeds@users.noreply.github.com>"

ARG USER_AGENT="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:86.1) Gecko/20100101 Firefox/86.1" \
  UBUNTU_VERSION="focal" \
  USERNAME="nanoseeds" \
  GCC_NOW_VERSION="9" \
  GCC_NEWEST_VERSION="11" \
  CMAKE_VERSION="3.20.5-0kitware1ubuntu20.04.1" \
  MINICONDA="Miniconda3-py39_4.9.2-Linux-x86_64.sh" \
  ETC_APT_SOURCES_LIST="FROM_ENV_ARG" \
  ETC_SSH_SSHD_CONFIG="FROM_ENV_ARG" \
  HOME_DOTFILES_GITCONFIG="FROM_ENV_ARG" \
  HOME_DOTFILES_GITCOMMIT="FROM_ENV_ARG" \
  HOME_DOTFILES_CONDARC="FROM_ENV_ARG" \
  HOME_DOTFILES_VIMRC="FROM_ENV_ARG" \
  HOME_DOTFILES_CARGO_CONFIG="FROM_ENV_ARG" \
  HOME_DOTFILES_GRADLE="FROM_ENV_ARG" \
  HOME_DOTFILES_PIP_CONFE="FROM_ENV_ARG" \
  HOME_DOTFILES_M2_SETTINGS="FROM_ENV_ARG" \
  HOME_DOTFILES_ZSH_MINICONDA3="FROM_ENV_ARG" \
  HOME_DOTFILES_ZSHRC="FROM_ENV_ARG"

EXPOSE 22

RUN  echo  "${ETC_APT_SOURCES_LIST}" > /etc/apt/sources.list \
  && apt-get update && apt-get upgrade -y \
  && apt-get install apt-utils openssh-client openssh-server zsh -y

RUN  echo "${ETC_SSH_SSHD_CONFIG}" > /etc/ssh/sshd_config \
  && echo "root:root" | chpasswd \
  && LANG="zh_SG.UTF-8" \
  && useradd "${USERNAME}" -m -g sudo -s /usr/bin/zsh \
  && echo "${USERNAME}:${USERNAME}" | chpasswd \
  && chsh -s "/usr/bin/zsh" \
  && usermod -s "/usr/bin/zsh" "root" \
  && usermod -s "/usr/bin/zsh" "${USERNAME}" \
  && ln -sf /usr/share/zoneinfo/Asia/Singapore /etc/localtime

RUN  mkdir -p "/home/${USERNAME}/dotfiles"  \ 
  && mkdir -p "/home/${USERNAME}/dotfiles/git" \
  && mkdir -p "/home/${USERNAME}/.cargo" \ 
  && mkdir -p "/home/${USERNAME}/.gradle" \ 
  && mkdir -p "/home/${USERNAME}/.pip" \
  && mkdir -p "/home/${USERNAME}/.m2" \
  && mkdir -p "/home/${USERNAME}/zsh_include" \
  && touch    "/home/${USERNAME}/zsh_include/LD_LIBRARY_PATH.sh" \
  && echo  "${HOME_DOTFILES_GITCONFIG}" > "/home/${USERNAME}/dotfiles/git/gitconfig"  \
  && echo  "${HOME_DOTFILES_GITCOMMIT}" > "/home/${USERNAME}/dotfiles/git/gitcommit"  \
  && echo  "${HOME_DOTFILES_CONDARC}" > "/home/${USERNAME}/dotfiles/.condarc" \
  && echo  "${HOME_DOTFILES_VIMRC}"  > "/home/${USERNAME}/dotfiles/.vimrc" \
  && echo  "${HOME_DOTFILES_CARGO_CONFIG}"  > "/home/${USERNAME}/dotfiles/.cargo.config.toml" \
  && echo  "${HOME_DOTFILES_GRADLE}" > "/home/${USERNAME}/dotfiles/init.gradle" \
  && echo  "${HOME_DOTFILES_PIP_CONF}" >  "/home/${USERNAME}/dotfiles/pip.conf" \
  && echo  "${HOME_DOTFILES_M2_SETTINGS}" > "/home/${USERNAME}/dotfiles/.m2.settings.xml" \
  && echo  "${HOME_DOTFILES_ZSHRC}" > "/home/${USERNAME}/dotfiles/.zshrc" \
  && echo  "${HOME_DOTFILES_ZSH_MINICONDA3}" > "/home/${USERNAME}/zsh_include/miniconda3.sh" \
  && ln -s  "/home/${USERNAME}/dotfiles/git/gitconfig"  "/home/${USERNAME}/.gitconfig" \
  && ln -s  "/home/${USERNAME}/dotfiles/.condarc"  "/home/${USERNAME}/.condarc" \
  && ln -s  "/home/${USERNAME}/dotfiles/.vimrc"   "/home/${USERNAME}/.vimrc" \
  && ln -s  "/home/${USERNAME}/dotfiles/.cargo.config.toml"   "/home/${USERNAME}/.cargo/config" \
  && ln -s  "/home/${USERNAME}/dotfiles/.init.gradle"    "/home/${USERNAME}/.gradle/init.gradle" \
  && ln -s  "/home/${USERNAME}/dotfiles/pip.conf"    "/home/${USERNAME}/.pip/pip.conf" \
  && ln -s  "/home/${USERNAME}/dotfiles/m2.settings.xml"  "/home/${USERNAME}/.m2/settings.xml" \
  && ln -s  "/home/${USERNAME}/dotfiles/.zshrc" "/home/${USERNAME}/.zshrc" \
  && ln -s  "/home/${USERNAME}/.oh-my-zsh" "/root/.oh-my-zsh" \
  && ln -s  "/home/${USERNAME}/zsh_include/miniconda3.sh"   "/home/${USERNAME}/zsh_include/conda.sh" \
  && chown -R "${USERNAME}:root" "/home/${USERNAME}/dotfiles/git/gitconfig" \
  && chown -R "${USERNAME}:root" "/home/${USERNAME}/dotfiles/git/gitcommit" \
  && chown -R "${USERNAME}:root" "/home/${USERNAME}/dotfiles/.condarc" \
  && chown -R "${USERNAME}:root" "/home/${USERNAME}/dotfiles/.vimrc" \
  && chown -R "${USERNAME}:root" "/home/${USERNAME}/dotfiles/.cargo.config.toml" \
  && chown -R "${USERNAME}:root" "/home/${USERNAME}/dotfiles/init.gradle" \
  && chown -R "${USERNAME}:root" "/home/${USERNAME}/dotfiles/pip.conf" \
  && chown -R "${USERNAME}:root" "/home/${USERNAME}/dotfiles/.m2.settings.xml" \
  && chown -R "${USERNAME}:root" "/home/${USERNAME}/dotfiles/.zshrc" \
  && chown -R "${USERNAME}:root" "/home/${USERNAME}/zsh_include/miniconda3.sh"

RUN  apt-get update && apt-get upgrade -y \
  && apt-get -y install git build-essential manpages-dev \
  make ffmpeg libssl-dev openssl net-tools vim xclip sudo \
  curl wget screen gdb zip tree neofetch transmission \
  && apt-get install -y \
  proxychains4 exiftool rename aria2 manpages-dev keychain \
  lsb-core openssh-client openssh-server traceroute htop pigz \
  && apt-get install -y software-properties-common \
  && apt-get install -y apt-transport-https ca-certificates gnupg 

RUN add-apt-repository ppa:ubuntu-toolchain-r/test -y \
  &&  apt-get update && apt-get upgrade -y \
  &&  apt-get install -y gcc-"${GCC_NEWEST_VERSION}" g++-"${GCC_NEWEST_VERSION}" \
  &&  gcc-"${GCC_NEWEST_VERSION}" --version \
  &&  update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-${GCC_NEWEST_VERSION} 1110 \
  &&  update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-${GCC_NOW_VERSION} 930 \
  &&  update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-${GCC_NEWEST_VERSION} 1110 \
  &&  update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-${GCC_NOW_VERSION} 930 

RUN  wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null \
  |  gpg --dearmor - \
  |  tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null \
  && echo "deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ focal main" \
  |  tee /etc/apt/sources.list.d/kitware.list >/dev/null \
  && apt-get update && apt-get upgrade -y \
  && rm /usr/share/keyrings/kitware-archive-keyring.gpg \
  && apt-get install kitware-archive-keyring \
  && echo "deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ focal-rc main" \
  | tee -a /etc/apt/sources.list.d/kitware.list >/dev/null \
  && apt-get update && apt-get upgrade -y \
  && apt-get -y install cmake-data="${CMAKE_VERSION}" cmake="${CMAKE_VERSION}" \
  && apt-mark hold cmake cmake-data

RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add \
  && add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ \
  && add-apt-repository ppa:openjdk-r/ppa -y \
  && apt-get update && apt-get upgrade -y \
  && apt-get install -y openjdk-8-jdk \
  && apt-get install -y openjdk-11-jdk \
  && apt-get install -y openjdk-17-jdk \
  && apt-get install -y maven gradle ant

RUN  add-apt-repository ppa:longsleep/golang-backports -y \
  && apt-get update && apt-get upgrade -y \
  && apt-get install -y golang-go

RUN   wget -c https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/"${MINICONDA}" \
  --user-agent="${USER_AGENT}" \
  --no-check-certificate \
  && sudo chmod 0755 ./"${MINICONDA}" \
  && bash  ./"${MINICONDA}" -b -p /home/${USERNAME}/miniconda3 \
  && rm ./"${MINICONDA}"

RUN curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash - \
  && sudo apt-get install -y nodejs

COPY ".oh-my-zsh" "/home/${USERNAME}/.oh-my-zsh"

RUN chmod -R 0755 "/home/${USERNAME}/.oh-my-zsh" \
  && chown -R "${USERNAME}:root" "/home/${USERNAME}"

ENTRYPOINT ["/bin/bash", "-c", "service ssh restart && bash"]

