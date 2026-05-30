FROM ghcr.io/certseeds/sshable AS conda-bootstrap

RUN curl -fsSL "https://mirrors.tuna.tsinghua.edu.cn/github-release/conda-forge/miniforge/LatestRelease/Miniforge3-Linux-x86_64.sh" \
  -o /tmp/miniforge.sh

RUN bash /tmp/miniforge.sh -b -p /opt/conda \
  && rm /tmp/miniforge.sh

RUN /opt/conda/bin/conda config \
    --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/ \
  && /opt/conda/bin/conda config \
    --remove channels defaults 2>/dev/null || true \
  && /opt/conda/bin/conda config \
    --set show_channel_urls yes


FROM conda-bootstrap AS cmake-builder

RUN /opt/conda/bin/conda create \
    -y \
    -p /opt/cmake cmake \
  && rm -rf /opt/conda/pkgs \
  && /opt/cmake/bin/cmake --version


FROM conda-bootstrap AS ccache-builder

RUN /opt/conda/bin/conda create \
    -y \
    -p /opt/ccache ccache \
  && rm -rf /opt/conda/pkgs \
  && /opt/ccache/bin/ccache --version


FROM conda-bootstrap AS gcc-builder

RUN /opt/conda/bin/conda create \
    -y \
    -p /opt/gcc \
      gcc_linux-64 \
      gxx_linux-64 \
      gdb \
      make \
  && ln -s x86_64-conda-linux-gnu-gcc /opt/gcc/bin/gcc \
  && ln -s x86_64-conda-linux-gnu-g++ /opt/gcc/bin/g++ \
  && mkdir -p /opt/gcc/bin/.gdb-deps \
  && mv /opt/gcc/bin/python* /opt/gcc/bin/.gdb-deps/ \
  && mv /opt/gcc/bin/pip* /opt/gcc/bin/.gdb-deps/ \
  && mv /opt/gcc/bin/pydoc* /opt/gcc/bin/.gdb-deps/ \
  && mv /opt/gcc/bin/idle* /opt/gcc/bin/.gdb-deps/ \
  && mv /opt/gcc/bin/pygmentize /opt/gcc/bin/.gdb-deps/ \
  && mv /opt/gcc/bin/sqlite3_analyzer /opt/gcc/bin/.gdb-deps/ \
  && rm -rf /opt/conda/pkgs \
  && /opt/gcc/bin/gcc --version \
  && /opt/gcc/bin/g++ --version \
  && /opt/gcc/bin/gdb --version \
  && /opt/gcc/bin/make --version

FROM ghcr.io/certseeds/sshable:latest AS py3-standalone-builder

ARG PYTHON_BUILD_DATE
ARG PYTHON_VERSION
ARG PYTHON_BINARY_TYPE

RUN curl -fsSL "https://registry.npmmirror.com/-/binary/python-build-standalone/${PYTHON_BUILD_DATE}/cpython-${PYTHON_VERSION}+${PYTHON_BUILD_DATE}-${PYTHON_BINARY_TYPE}-unknown-linux-gnu-install_only.tar.gz" \
  -o /tmp/python.tar.gz

RUN mkdir -p /opt/python \
  && (tar xf /tmp/python.tar.gz \
    -C /opt/python \
    --strip-components=1 \
    --no-same-owner --no-same-permissions \
      > /dev/null 2>&1 || true)\
  && /opt/python/bin/python3 --version

FROM py3-standalone-builder AS uv-builder

RUN /opt/python/bin/pip install uv \
  --index-url https://mirrors.aliyun.com/pypi/simple \
  && mkdir -p /opt/uv \
  && cp /opt/python/bin/uv /opt/uv/ \
  && cp /opt/python/bin/uvx /opt/uv/

FROM ghcr.io/certseeds/sshable:latest AS node-builder

ARG NODE_VERSION

RUN curl -fsSL "https://registry.npmmirror.com/-/binary/node/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64.tar.gz" \
  -o /tmp/node.tar.gz

RUN  mkdir -p /opt/node-lts \
  && (tar xf /tmp/node.tar.gz \
    -C /opt/node-lts \
    --strip-components=1 \
    --no-same-owner \
    --no-same-permissions \
      > /dev/null 2>&1 || true) \
  && /opt/node-lts/bin/node --version

FROM node-builder AS pnpm-builder

ARG PNPM_VERSION
ENV PATH="/opt/node-lts/bin:${PATH}"

RUN /opt/node-lts/bin/npm install -g pnpm@${PNPM_VERSION} \
    --registry=https://registry.npmmirror.com \
  && cp -r /opt/node-lts/lib/node_modules/pnpm /opt/pnpm \
  && cp /opt/pnpm/bin/pnpm.cjs /opt/pnpm/bin/pnpm \
  && chmod +x /opt/pnpm/bin/pnpm

FROM ghcr.io/certseeds/sshable:latest

COPY --from=uv-builder /opt/uv /opt/uv
COPY --from=py3-standalone-builder /opt/python /opt/python
COPY --from=node-builder /opt/node-lts /opt/node-lts
COPY --from=pnpm-builder /opt/pnpm /opt/pnpm
COPY --from=cmake-builder /opt/cmake /opt/cmake
COPY --from=ccache-builder /opt/ccache /opt/ccache
COPY --from=gcc-builder /opt/gcc /opt/gcc

ENV PATH="/opt/uv:${PATH}"
ENV PATH="/opt/python/bin:${PATH}"
ENV PATH="/opt/node-lts/bin:${PATH}"
ENV PATH="/opt/pnpm/bin:${PATH}"
ENV PATH="/opt/cmake/bin:${PATH}"
ENV PATH="/opt/ccache/bin:${PATH}"
ENV PATH="/opt/gcc/bin:${PATH}"

USER ${USERNAME}
WORKDIR /home/${USERNAME}
ENV PATH="/home/${USERNAME}/.local/share/pnpm/bin:${PATH}"

RUN mkdir -p /home/${USERNAME}/.config/pip \
  /home/${USERNAME}/.config/uv \
  /home/${USERNAME}/.config/pnpm \
  /home/${USERNAME}/.local/share/pnpm/bin

COPY --chown=${USERNAME}: ./lang/pip.conf /home/${USERNAME}/.config/pip/pip.conf
COPY --chown=${USERNAME}: ./lang/uv.toml /home/${USERNAME}/.config/uv/uv.toml
COPY --chown=${USERNAME}: ./lang/.npmrc /home/${USERNAME}/.npmrc
COPY --chown=${USERNAME}: ./lang/pnpm.config.yaml /home/${USERNAME}/.config/pnpm/config.yaml
COPY --chown=${USERNAME}: ./lang/pnpm.config.rc /home/${USERNAME}/.config/pnpm/rc

ENTRYPOINT ["/bin/bash"]
