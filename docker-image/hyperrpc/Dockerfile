FROM rust:1.78-alpine as builder

RUN apk update \
  && apk add musl-dev git capnproto-dev \
  && git clone https://github.com/enviodev/local-hyperrpc \
  && cd local-hyperrpc \
  && cargo build --release

FROM alpine:3.18

COPY --from=builder /local-hyperrpc/target/release/local-hyperrpc /usr/local/bin/

