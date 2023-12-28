FROM --platform=$BUILDPLATFORM ghcr.io/foundry-rs/foundry:latest as foundry

FROM --platform=$BUILDPLATFORM golang:1.21.3-alpine3.18 as builder

WORKDIR /app

ARG GIT_BRANCH_OPTIMISM=develop
ARG GIT_BRANCH_GETH=optimism

COPY --from=foundry /usr/local/bin/anvil /usr/local/bin
COPY --from=foundry /usr/local/bin/cast /usr/local/bin
COPY --from=foundry /usr/local/bin/chisel /usr/local/bin
COPY --from=foundry /usr/local/bin/forge /usr/local/bin

RUN apk add --no-cache make gcc musl-dev gcompat linux-headers git jq bash curl npm \
    && npm i -g pnpm

RUN git clone https://github.com/ethereum-optimism/optimism --branch=$GIT_BRANCH_OPTIMISM \
    && cd optimism \
    && pnpm install \
    && make op-node op-batcher op-proposer \
    && pnpm build

RUN git clone https://github.com/ethereum-optimism/op-geth --branch=$GIT_BRANCH_GETH \
    && cd op-geth \
    && make geth


FROM alpine:3.18

COPY --from=builder /app/op-geth/build/bin/geth /usr/local/bin/
COPY --from=builder /app/optimism/op-node/bin/op-node /usr/local/bin/
COPY --from=builder /app/optimism/op-batcher/bin/op-batcher /usr/local/bin/
COPY --from=builder /app/optimism/op-proposer/bin/op-proposer /usr/local/bin/


