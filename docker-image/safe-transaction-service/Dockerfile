FROM safeglobal/safe-transaction-service:v4.18.6

RUN apt-get update -y \
  && apt-get install -y git gcc \
  && rm -rf /var/lib/apt/lists/* \
  && git clone -b support-darwinia https://github.com/fewensa/safe-transaction-service tmp \
  && rm -rf safe_transaction_service \
  && mv tmp/safe_transaction_service ./ \
  && rm -rf tmp \
  && pip uninstall -y safe-eth-py \
  && pip install git+https://github.com/dcdao/safe-eth-py.git@support-darwinia

