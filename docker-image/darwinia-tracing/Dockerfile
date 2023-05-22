# ARG DARWINIA_VERSION
# FROM ghcr.io/darwinia-network/darwinia:$DARWINIA_VERSION
# COPY --from=downloader ./darwinia /home/$USERNAME/darwinia-nodes/darwinia

# FROM alpine:3 as downloader
# ARG DARWINIA_VERSION
# RUN apk update \
#   && apk add curl bzip2 \
#   && curl -LO https://github.com/darwinia-network/darwinia/releases/download/$DARWINIA_VERSION/darwinia-tracing-x86_64-linux-gnu.tar.bz2 \
#   && tar -xvf darwinia-tracing-x86_64-linux-gnu.tar.bz2 -C ./


ARG DARWINIA_VERSION

FROM ghcr.io/darwinia-network/darwinia:$DARWINIA_VERSION

ARG DARWINIA_VERSION

RUN sudo apt-get update \
  && sudo apt-get install -y --no-install-recommends curl bzip2 \
  && sudo rm -rf /var/lib/apt/lists/* \
  && curl -LO https://github.com/darwinia-network/darwinia/releases/download/$DARWINIA_VERSION/darwinia-tracing-x86_64-linux-gnu.tar.bz2 \
  && tar -xvf darwinia-tracing-x86_64-linux-gnu.tar.bz2 -C /home/darwinia/darwinia-nodes/

COPY darwinia-tracing /home/darwinia/darwinia-nodes/
