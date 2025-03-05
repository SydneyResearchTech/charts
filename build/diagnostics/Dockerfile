FROM debian:unstable-slim
ARG DOCKER_IMAGE_TAG=0.4.0

ENV DEBIAN_FRONTEND=noninteractive

RUN <<EOF
apt-get update
apt-get -y install \
 bind9-dnsutils \
 fio fio-examples \
 iperf3 \
 iproute2 \
 iputils-ping \
 openssl \
 strace
rm -rf /var/lib/apt/lists/*
EOF

COPY ./ /
