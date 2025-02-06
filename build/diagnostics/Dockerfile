FROM debian:unstable-slim
ARG DOCKER_IMAGE_TAG=0.2.0

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y install \
 dnsutils \
 iperf3 \
 iproute2 \
 iputils-ping \
 && rm -rf /var/lib/apt/lists/*

COPY ./ /
