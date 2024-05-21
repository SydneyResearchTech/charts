ARG CUDA_VER=12.2.2
FROM nvidia/cuda:${CUDA_VER}-base-ubuntu22.04
ARG LICENSE_ID
ARG CRYOSPARC_VERSION=v4.4.1
ARG DOCKER_IMAGE_TAG=0.1.0

ENV LICENSE_ID=${LICENSE_ID}

RUN <<EOT
  apt-get update
  apt-get -y install curl
  rm -rf /var/lib/apt/lists/*
  curl -L https://get.cryosparc.com/download/worker-${CRYOSPARC_VERSION}/$LICENSE_ID -o cryosparc_worker.tar.gz
  tar -xzf cryosparc_worker.tar.gz cryosparc_worker
  rm -f cryosparc_worker.tar.gz
EOT

RUN <<EOT
  cd /cryosparc_worker
  ./install.sh --license ${LICENSE_ID} --yes
  rm -rf /var/lib/apt/lists/*
EOT

RUN <<EOT
  sed -i 's/^export\s*CRYOSPARC_LICENSE_ID=.*$/export CRYOSPARC_LICENSE_ID=""/' /cryosparc_worker/config.sh
  echo 'eval $(/cryosparc_worker/bin/cryosparcw env)' >>/etc/bash.bashrc
  cp /cryosparc_worker/config.sh /cryosparc_worker/config.sh-orig
  useradd -c 'CryoSPARC user' -m -s /bin/sh cryosparc
  apt-get update
  apt-get -y install \
    dropbear
  rm -rf /var/lib/apt/lists/*
EOT

COPY ./ /

ENV CRYOSPARC_HOSTNAME="" \
    CRYOSPARC_MASTER="cryosparcm" \
    CRYOSPARC_PORT="39000" \
    CRYOSPARC_SSDPATH="" \
    CRYOSPARC_UPDATE="" \
    CRYOSPARC_SSHSTR="" \
    CRYOSPARC_CPUS="" \
    CRYOSPARC_NOGPU="" \
    CRYOSPARC_GPUS="" \
    CRYOSPARC_SSDQUOTA="" \
    CRYOSPARC_SSDRESERVE="" \
    CRYOSPARC_LANE="" \
    CRYOSPARC_NEWLANE=""

ENTRYPOINT ["/entrypoint.sh"]
CMD ["cryosparcw","connect"]
WORKDIR /cryosparc_worker
ENV PYTHONDONTWRITEBYTECODE=1 \
    PATH="/cryosparc_worker/bin:${PATH}" \
    USER=cryosparc \
    CRYOSPARC_VERSION=${CRYOSPARC_VERSION} \
    CRYOSPARC_LICENSE_ID=""
