#!/usr/bin/env bash
set -e
[[ -f ../.env ]] && source ../.env
[[ -z $LICENSE_ID ]] && { >&2 echo "set LICENSE_ID"; exit 1; }

docker buildx build \
	--build-arg="LICENSE_ID=${LICENSE_ID}" \
	--progress=plain \
	--tag localhost:32000/cryosparc-master:0.1.0 . 2>&1 \
	|tee log-buildx-$(date '+%Y%m%d%H%M%S')

docker push localhost:32000/cryosparc-master:0.1.0
