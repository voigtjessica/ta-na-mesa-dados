FROM python:3.6.4-alpine3.7

COPY ./requirements.txt /code/scripts/requirements.txt

RUN set -ex && \
    apk update && apk add --no-cache curl tzdata libpq && \    
     apk update && apk add --no-cache \
      --virtual=.build-dependencies \
      gcc \
      git \
      python3-dev && \
    python -m pip --no-cache install -U pip && \
    python -m pip --no-cache install -r /code/scripts/requirements.txt && \
    apk del --purge .build-dependencies

WORKDIR /code/scripts/

COPY ./ ./