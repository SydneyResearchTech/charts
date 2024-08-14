FROM debian:latest
ARG DOCKER_IMAGE_TAG=latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y install \
 ca-certificates \
 && rm -rf /var/lib/apt/lists/*

COPY ./ /
