ARG DOCKER_IMAGE_TAG=1.0.0

FROM debian:trixie-slim

RUN <<EOT
  apt-get update
  apt-get -y install \
    iproute2 \
    iptables \
    tayga
  rm -rf /var/lib/apt/lists/*
EOT

COPY --chmod=755 ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY ./tayga.conf /etc/tayga.conf

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["tayga"]
