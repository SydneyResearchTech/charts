#!/usr/bin/env bash
set -e
[[ -f ../.env ]] && source ../.env
[[ -z $LICENSE_ID ]] && { >&2 echo "set LICENSE_ID"; exit 1; }

[[ -z $DOCKER_IMAGE_TAG ]] && \
	DOCKER_IMAGE_TAG="$(sed -n 's/^ARG\s\+DOCKER_IMAGE_TAG=\(.*\)$/\1/p' ./Dockerfile)"

docker buildx build \
	--build-arg="LICENSE_ID=${LICENSE_ID}" \
	--progress=plain \
	--tag localhost:32000/cryosparc-master:${DOCKER_IMAGE_TAG} . 2>&1 \
	|tee log-buildx-$(date '+%Y%m%d%H%M%S')

docker push localhost:32000/cryosparc-master:${DOCKER_IMAGE_TAG}
