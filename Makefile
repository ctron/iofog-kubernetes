.PHONY: all

all: build tag push

CONTAINERS = base controller
VERSION ?= latest
CONTAINER_REGISTRY ?= ghcr.io/ctron

.PHONY: build
build:
	for i in $(CONTAINERS); do \
  		podman build . -f containers/iofog-$$i/Dockerfile -t iofog-$$i; \
  	done

.PHONY: tag
tag:
	for i in $(CONTAINERS); do \
  		podman tag iofog-$$i $(CONTAINER_REGISTRY)/iofog-$$i:$(VERSION); \
  	done

.PHONY: push
push:
	for i in $(CONTAINERS); do \
  		podman push $(CONTAINER_REGISTRY)/iofog-$$i:$(VERSION); \
  	done

sync-helm:
	rsync -av charts/iofog ~/git/helm-charts/charts/
