# Copyright 2021 Hewlett Packard Enterprise Development LP

IMAGE_NAME ?= cray-nexus-setup
VERSION ?= $(shell cat .version)

image:
	docker build --pull ${DOCKER_ARGS} --tag '${IMAGE_NAME}:${VERSION}' .
	docker images
