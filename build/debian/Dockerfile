FROM debian:12
ARG DOCKER_IMAGE_TAG=1.3.0

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y install \
 ca-certificates \
 curl \
 gettext-base \
 postgresql-client-common \
 && rm -rf /var/lib/apt/lists/*

COPY ./ /
