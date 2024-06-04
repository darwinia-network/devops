FROM alpine:3 as step0

RUN apk update \
  && apk add curl \
  && curl -L -o /tmp/paseo.raw.json https://raw.githubusercontent.com/paseo-network/runtimes/main/chain-specs/paseo.raw.json \
  && chown 1000:1000 /tmp/paseo.raw.json


FROM ghcr.io/darwinia-network/darwinia:koi-6630

COPY --from=step0 /tmp/paseo.raw.json /home/darwinia/darwinia-nodes/paseo.raw.json
