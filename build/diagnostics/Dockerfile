FROM debian:unstable-slim
ARG DOCKER_IMAGE_TAG=0.1.0

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y install \
 iperf3 \
 && rm -rf /var/lib/apt/lists/*

COPY ./ /
