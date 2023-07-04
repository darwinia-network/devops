# FROM safeglobal/safe-transaction-service:v4.18.6

# RUN apt-get update -y \
#   && apt-get install -y git gcc \
#   && rm -rf /var/lib/apt/lists/* \
#   && git clone -b support-darwinia https://github.com/fewensa/safe-transaction-service tmp \
#   && rm -rf safe_transaction_service \
#   && mv tmp/safe_transaction_service ./ \
#   && rm -rf tmp \
#   && pip uninstall -y safe-eth-py \
#   && pip install git+https://github.com/furoxr/safe-eth-py.git@support-darwinia


FROM python:3.10-slim

ARG APP_HOME=/app
WORKDIR ${APP_HOME}
ENV PYTHONUNBUFFERED=1

# https://eth-hash.readthedocs.io/en/latest/quickstart.html#specify-backend-by-environment-variable
# `pysha3` is way faster than `pycryptodome` for CPython
ENV ETH_HASH_BACKEND=pysha3

RUN set -ex \
	&& buildDeps=" \
		build-essential \
        git \
		libssl-dev \
        libpq-dev \
		" \
    && apt-get update \
    && apt-get install -y --no-install-recommends $buildDeps tmux postgresql-client \
    && git clone -b support-darwinia https://github.com/fewensa/safe-transaction-service tmp 

RUN cp tmp/requirements.txt ./

RUN pip install -U --no-cache-dir wheel setuptools pip \
    && pip install --no-cache-dir -r requirements.txt \
    && apt-get purge -y --auto-remove $buildDeps \
    && rm -rf /var/lib/apt/lists/* \
    && find /usr/local \
        \( -type d -a -name test -o -name tests \) \
        -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
        -exec rm -rf '{}' +

RUN mv tmp/* . && rm -rf tmp

RUN DJANGO_SETTINGS_MODULE=config.settings.production DJANGO_DOT_ENV_FILE=.env.tracing.sample python manage.py collectstatic --noinput

