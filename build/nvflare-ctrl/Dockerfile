FROM python:3.9
ARG DOCKER_IMAGE_TAG=1.0.0
LABEL org.opencontainers.image.authors="dean.taylor@sydney.edu.au"

COPY ./ /

RUN <<EOT
python -m pip install -U pip
python -m pip install -r /requirements.txt
EOT

ENTRYPOINT ['entrypoint.sh']
CMD ['python','/usr/local/bin/ctrl.py']
