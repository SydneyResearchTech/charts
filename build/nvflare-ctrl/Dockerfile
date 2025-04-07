FROM python:3.9
ARG DOCKER_IMAGE_TAG=1.2.0
LABEL org.opencontainers.image.authors="dean.taylor@sydney.edu.au"

COPY ./ /

RUN <<EOT
python3 -m pip install -U pip
python3 -m pip install -r /requirements.txt
EOT

ENTRYPOINT ['entrypoint.sh']
CMD ['python3','/usr/local/bin/ctrl.py']
