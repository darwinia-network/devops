FROM alpine:3 as step0

RUN apk update \
  && apk add curl \
  && curl -L -o /tmp/koi.json https://raw.githubusercontent.com/paseo-network/runtimes/main/chain-specs/paseo.raw.json \
  && chown 1000:1000 /tmp/koi.json


FROM ghcr.io/darwinia-network/darwinia:koi-6630

COPY --from=step0 /tmp/koi.json /home/darwinia/darwinia-nodes/koi.json
