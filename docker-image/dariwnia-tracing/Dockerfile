ARG DARWINIA_VERSION=v6.3.0

FROM ghcr.io/darwinia-network/darwinia:${DARWINIA_VERSION}

RUN apt-get update \
  && apt-get install -y --no-install-recommends curl \
  && curl -LO https://github.com/darwinia-network/darwinia/releases/download/${DARWINIA_VERSION}/darwinia-tracing-x86_64-linux-gnu.tar.bz2 \ 
  && tar -xvf darwinia-tracing-x86_64-linux-gnu.tar.bz2 -C /home/darwinia/darwinia-nodes/

