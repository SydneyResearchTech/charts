ARG APP_VERSION=2.6.0
FROM nvflare/nvflare:${APP_VERSION}
ARG DOCKER_IMAGE_TAG=0.1.0

RUN <<EOT
python3 -m pip install --no-cache-dir --root-user-action=ignore \
 kubernetes
EOT
