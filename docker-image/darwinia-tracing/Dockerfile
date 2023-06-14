FROM debian:stable-slim

ARG DARWINIA_VERSION
ARG USERNAME=darwinia
ARG USER_UID=1000
ARG USER_GID=$USER_UID

COPY overridden-runtimes /home/$USERNAME/darwinia-nodes/overridden-runtimes

RUN groupadd --gid $USER_GID $USERNAME \
  && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
  && apt-get update && apt-get install -y --no-install-recommends sudo ca-certificates curl zstd \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
  && chmod 0440 /etc/sudoers.d/$USERNAME \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /data \
  && curl -LO https://github.com/darwinia-network/darwinia/releases/download/$DARWINIA_VERSION/darwinia-tracing-x86_64-linux-gnu.tar.zst \
  && tar -I zstd -xvf darwinia-tracing-x86_64-linux-gnu.tar.zst -C /home/darwinia/darwinia-nodes/ \
  && rm -rf darwinia-tracing-x86_64-linux-gnu.tar.zst \
  && chown -R $USERNAME:$USERNAME /home/$USERNAME \
  && chown -R $USERNAME:$USERNAME /data \
  && ln -s /home/$USERNAME/darwinia-nodes/darwinia /usr/local/bin/darwinia

USER $USERNAME
WORKDIR /home/$USERNAME/darwinia-nodes

EXPOSE 9933 9944

ENTRYPOINT [ "/usr/local/bin/darwinia" ]
