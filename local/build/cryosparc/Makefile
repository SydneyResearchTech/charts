CONFIG = .env
ifneq (,$(wildcard ${CONFIG}))
include ${CONFIG}
endif
ifndef LICENSE_ID
$(error LICENSE_ID is not set)
endif

DOCKER_IMAGE_TAG ?= 0.3.0
REGISTRY ?= localhost:3200
CUDA_VERSION ?= 12.2.2

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
		--build-arg="CUDA_VER=$(CUDA_VERSION)" \
		--build-arg="LICENSE_ID=$(LICENSE_ID)" \
		--progress=plain \
		--tag $(REGISTRY)/$(@:%/=%):$${DOCKER_IMAGE_TAG} $@ 2>&1 \
		|tee $@log-buildx-$(DATE)
	docker push $(REGISTRY)/$(@:%/=%):$${DOCKER_IMAGE_TAG}
