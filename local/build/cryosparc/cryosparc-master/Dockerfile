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
    iputils-ping
  cd cryosparc_master
  ./install.sh --license ${LICENSE_ID} \
               --hostname localhost \
               --dbpath /cryosparc_database \
               --port 39000 \
               --allowroot --yes
  rm -rf /var/lib/apt/lists/*
  echo 'eval $(/cryosparc_master/bin/cryosparcm env)' >>/etc/bash.bashrc
EOT

COPY ./ /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["cryosparcm","start"]
WORKDIR /cryosparc_master
ENV PYTHONDONTWRITEBYTECODE=1
