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

ENV PATH="/opt/uv:${PATH}"
ENV PATH="/opt/python/bin:${PATH}"
ENV PATH="/opt/node-lts/bin:${PATH}"
ENV PATH="/opt/pnpm/bin:${PATH}"

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
