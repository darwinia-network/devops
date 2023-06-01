FROM safeglobal/safe-transaction-service:v4.18.6

RUN apt-get update -y \
  && apt-get install -y git gcc \
  && rm -rf /var/lib/apt/lists/* 
  
RUN pip uninstall -y safe-eth-py \
  && pip install git+https://github.com/furoxr/safe-eth-py.git@support-darwinia

