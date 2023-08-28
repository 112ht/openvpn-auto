FROM ubuntu:20.04

RUN apt-get update && apt-get install -y openvpn iputils-ping net-tools dnsutils openssh-client curl

COPY tokyo-key-file-002.pem /tmp/
RUN chmod 600 tmp/tokyo-key-file-002.pem

# Shift timezone to Asia/Tokyo.
ENV TZ Asia/Tokyo

# Set local to jp.
RUN apt-get update && apt-get install -y language-pack-ja && \
    update-locale LANG=ja_JP.UTF-8 && rm -rf /var/lib/apt/lists/*
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

WORKDIR  /tmp/
