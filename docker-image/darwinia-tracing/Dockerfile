ARG DARWINIA_VERSION=v6.3.0

FROM ghcr.io/darwinia-network/darwinia:${DARWINIA_VERSION}

RUN sudo apt-get update \
  && sudo apt-get install -y --no-install-recommends curl \
  && sudo rm -rf /var/lib/apt/lists/* \
  && curl -LO https://github.com/darwinia-network/darwinia/releases/download/${DARWINIA_VERSION}/darwinia-tracing-x86_64-linux-gnu.tar.bz2 \ 
  && tar -xvf darwinia-tracing-x86_64-linux-gnu.tar.bz2 -C /home/darwinia/darwinia-nodes/

