FROM nvidia/cuda:11.7.1-base-ubuntu22.04
ARG LICENSE_ID

ENV LICENSE_ID=${LICENSE_ID}

RUN <<EOT
  apt-get update
  apt-get -y install curl
  rm -rf /var/lib/apt/lists/*
  curl -L https://get.cryosparc.com/download/worker-latest/$LICENSE_ID -o cryosparc_worker.tar.gz
  tar -xzf cryosparc_worker.tar.gz cryosparc_worker
  rm -f cryosparc_worker.tar.gz
EOT

RUN <<EOT
  cd /cryosparc_worker
  ./install.sh --license ${LICENSE_ID} --yes
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
    USER=cryosparc
