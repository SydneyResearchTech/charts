TAG ?= xnat-populate:0.1.0

all: build kind

build:
	docker build -t $(TAG) .
	sed -i '' 's/image: xnat-populate:.*$$/image: $(TAG)/' job.yaml

kind:
	kind load docker-image $(TAG)

.PHONY: all build kind
