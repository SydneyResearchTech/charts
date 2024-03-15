# charts/local/build/cryosparc/cryosparc-master/Dockerfile
#
FROM ubuntu:22.04 as build
ARG LICENSE_ID
ARG CRYOSPARC_VERSION=v4.4.1
ARG DOCKER_IMAGE_TAG=0.1.0

ENV LICENSE_ID=${LICENSE_ID}

RUN <<EOT
  apt-get update
  apt-get -y install \
    curl
  rm -rf /var/lib/apt/lists/*
  curl -L https://get.cryosparc.com/download/master-${CRYOSPARC_VERSION}/$LICENSE_ID -o cryosparc_master.tar.gz
  tar -xf cryosparc_master.tar.gz cryosparc_master
  rm -f cryosparc_master.tar.gz
EOT

RUN <<EOT
  apt-get update
  apt-get -y install \
    iputils-ping \
    openssh-client
  cd /cryosparc_master
  ./install.sh --license ${LICENSE_ID} \
               --hostname "buildkitsandbox" \
               --dbpath /cryosparc_database \
               --port 39000 \
               --allowroot --yes
  rm -rf /var/lib/apt/lists/*
EOT

RUN <<EOT
  sed -i 's/^export\s*CRYOSPARC_LICENSE_ID=.*$/export CRYOSPARC_LICENSE_ID=""/' /cryosparc_master/config.sh
  echo '' >>/cryosparc_master/config.sh
  echo '# Docker buildx' >>/cryosparc_master/config.sh
  echo 'export CRYOSPARC_FORCE_HOSTNAME=true' >>/cryosparc_master/config.sh
  echo 'export CRYOSPARC_FORCE_USER=true' >>/cryosparc_master/config.sh
  echo 'eval $(cryosparcm env)' >>/etc/bash.bashrc
  cp /cryosparc_master/config.sh /cryosparc_master/config.sh-orig
  cp /cryosparc_master/supervisord.conf /cryosparc_master/supervisord.conf-orig
  useradd -c 'CryoSPARC user' -m -s /usr/sbin/nologin cryosparc
EOT

COPY ./ /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["cryosparcm","start"]
WORKDIR /cryosparc_master
ENV PYTHONDONTWRITEBYTECODE=1 \
    TERM="xterm" \
    PATH="/cryosparc_master/bin:${PATH}" \
    CRYOSPARC_VERSION=${CRYOSPARC_VERSION} \
    CRYOSPARC_LICENSE_ID=""
