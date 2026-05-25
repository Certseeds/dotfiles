FROM ghcr.io/certseeds/sshable


RUN export DEBIAN_FRONTEND=noninteractive \
  && yes | apt-get update \
  && yes | apt-get upgrade \
  && yes | apt-get install build-essential cmake gdb make ccache \
      --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

