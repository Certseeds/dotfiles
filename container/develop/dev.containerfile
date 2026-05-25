FROM ghcr.io/certseeds/sshable:latest AS uv-builder

RUN export DEBIAN_FRONTEND=noninteractive \
  && yes | apt-get update \
  && yes | apt-get install pipx --no-install-recommends

RUN pipx install uv \
  --index-url https://mirrors.aliyun.com/pypi/simple \
  && mkdir -p /opt/uv \
  && cp "$(pipx environment --value PIPX_LOCAL_VENVS)/uv/bin/uv" /opt/uv/ \
  && cp "$(pipx environment --value PIPX_LOCAL_VENVS)/uv/bin/uvx" /opt/uv/

FROM ghcr.io/certseeds/sshable:latest AS py3-standalone-builder

ARG PYTHON_BUILD_DATE
ARG PYTHON_VERSION
ARG PYTHON_BINARY_TYPE

RUN mkdir -p /opt/python \
  && curl -fsSL "https://registry.npmmirror.com/-/binary/python-build-standalone/${PYTHON_BUILD_DATE}/cpython-${PYTHON_VERSION}+${PYTHON_BUILD_DATE}-${PYTHON_BINARY_TYPE}-unknown-linux-gnu-install_only.tar.gz" \
  | tar xz -C /opt/python --strip-components=1

FROM ghcr.io/certseeds/sshable:latest AS node-builder

ARG NODE_VERSION

RUN mkdir -p /opt/node-lts \
  && curl -fsSL "https://registry.npmmirror.com/-/binary/node/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64.tar.gz" \
  | tar xz -C /opt/node-lts --strip-components=1

FROM ghcr.io/certseeds/sshable:latest AS pnpm-builder

ARG PNPM_VERSION

RUN mkdir -p /opt/pnpm/bin \
  && curl -fsSL "https://registry.npmmirror.com/pnpm/-/pnpm-${PNPM_VERSION}.tgz" \
  | tar xz -C /opt/pnpm --strip-components=1 \
  && cp /opt/pnpm/bin/pnpm.cjs /opt/pnpm/bin/pnpm \
  && chmod +x /opt/pnpm/bin/pnpm

FROM ghcr.io/certseeds/sshable:latest

ENV USERNAME="nanoseeds"
WORKDIR /home/${USERNAME}

COPY --from=uv-builder /opt/uv /opt/uv
COPY --from=py3-standalone-builder /opt/python /opt/python
COPY --from=node-builder /opt/node-lts /opt/node-lts
COPY --from=pnpm-builder /opt/pnpm /opt/pnpm

ENV PATH="/opt/uv:${PATH}"
ENV PATH="/opt/python/bin:${PATH}"
ENV PATH="/opt/node-lts/bin:${PATH}"
ENV PATH="/opt/pnpm/bin:${PATH}"

USER ${USERNAME}

RUN mkdir -p /home/${USERNAME}/.config/pip \
  /home/${USERNAME}/.config/uv \
  /home/${USERNAME}/.config/pnpm

COPY --chown=${USERNAME}: ./lang/pip.conf /home/${USERNAME}/.config/pip/pip.conf
COPY --chown=${USERNAME}: ./lang/uv.toml /home/${USERNAME}/.config/uv/uv.toml
COPY --chown=${USERNAME}: ./lang/.npmrc /home/${USERNAME}/.npmrc
COPY --chown=${USERNAME}: ./lang/pnpm.config.yaml /home/${USERNAME}/.config/pnpm/config.yaml
COPY --chown=${USERNAME}: ./lang/pnpm.config.rc /home/${USERNAME}/.config/pnpm/rc

ENTRYPOINT ["/bin/bash"]
