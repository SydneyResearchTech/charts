# charts/local/build/cryosparc/cryosparc-master/Dockerfile
#
FROM ubuntu:22.04 as build
ARG LICENSE_ID

ENV LICENSE_ID=${LICENSE_ID}

RUN <<EOT
  apt-get update
  apt-get -y install \
    curl
  rm -rf /var/lib/apt/lists/*
  curl -L https://get.cryosparc.com/download/master-latest/$LICENSE_ID -o cryosparc_master.tar.gz
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
  useradd -c 'CryoSPARC user' -m -s /usr/sbin/nologin cryosparc
  echo 'eval $(/cryosparc_master/bin/cryosparcm env)' >>/etc/bash.bashrc
  cp /cryosparc_master/config.sh /cryosparc_master/config.sh-orig
EOT

RUN <<EOT
  echo >>/cryosparc_master/config.sh
  echo '# Docker buildx' >>/cryosparc_master/config.sh
  echo 'export CRYOSPARC_FORCE_HOSTNAME=true' >>/cryosparc_master/config.sh
  echo 'export CRYOSPARC_FORCE_USER=true' >>/cryosparc_master/config.sh
  cp /cryosparc_master/supervisord.conf /cryosparc_master/supervisord.conf-orig
EOT

COPY ./ /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["cryosparcm","start"]
WORKDIR /cryosparc_master
ENV PYTHONDONTWRITEBYTECODE=1
