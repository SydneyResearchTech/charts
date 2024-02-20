CONFIG = .env
ifneq (,$(wildcard ${CONFIG}))
include ${CONFIG}
endif
ifndef LICENSE_ID
$(error LICENSE_ID is not set)
endif

#SUBDIRS := $(wildcard */.)
DATE := $(shell date '+%Y%m%d%H%M%S')
DOCKERFILES := $(shell find . -name Dockerfile -type f)
SUBDIRS := $(filter-out ./,$(dir $(DOCKERFILES)))

.PHONY : all $(SUBDIRS)
all : $(SUBDIRS)

.ONESHELL:
SHELL = /usr/bin/bash
$(SUBDIRS) :
	DOCKER_IMAGE_TAG="$(DOCKER_IMAGE_TAG)"
	[[ -z $$DOCKER_IMAGE_TAG ]] && \
		DOCKER_IMAGE_TAG="$$(sed -n 's/^ARG\s\+DOCKER_IMAGE_TAG=\(.*\)$$/\1/p' $@Dockerfile)"
	docker buildx build \
		--build-arg="LICENSE_ID=$(LICENSE_ID)" \
		--progress=plain \
		--tag localhost:32000/$(@:%/=%):$${DOCKER_IMAGE_TAG} $@ 2>&1 \
		|tee $@log-buildx-$(DATE)
	docker push localhost:32000/$(@:%/=%):$${DOCKER_IMAGE_TAG}
