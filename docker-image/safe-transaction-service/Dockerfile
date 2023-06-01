FROM safeglobal/safe-transaction-service:v4.19.3

RUN apt-get update -y \
  && apt-get install -y git \
  && rm -rf /var/lib/apt/lists/* \
  && pip uninstall -y safe-eth-py \
  && pip install git+https://github.com/furoxr/safe-eth-py.git@support-darwinia

