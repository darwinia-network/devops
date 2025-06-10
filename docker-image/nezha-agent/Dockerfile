FROM alpine:3.21

ARG NEZHA_AGENT_VERSION=v1.12.3

ADD https://github.com/nezhahq/agent/releases/download/$NEZHA_AGENT_VERSION/nezha-agent_linux_amd64.zip /tmp

RUN unzip /tmp/nezha-agent_linux_amd64.zip -d /usr/local/bin && rm /tmp/nezha-agent_linux_amd64.zip

RUN addgroup -S nezha && adduser -S -D -h /home/nezha -G nezha nezha
USER nezha

ENTRYPOINT ["nezha-agent"]


