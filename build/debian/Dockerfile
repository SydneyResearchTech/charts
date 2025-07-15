FROM debian:12
ARG DOCKER_IMAGE_TAG=1.2.0

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y install \
 ca-certificates \
 curl \
 gettext-base \
 && rm -rf /var/lib/apt/lists/*

COPY ./ /
