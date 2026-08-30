TAG ?= unfs3:0.1.0

all: build kind deploy

build:
	docker build -t $(TAG) .

kind:
	kind load docker-image $(TAG)

deploy:
	sed -i '' 's/image: unfs3:.*$$/image: $(TAG)/' deploy.yaml
	kubectl apply -f deploy.yaml

.PHONY: all build kind deploy
