#!/bin/bash

# Copyright 2020 Hewlett Packard Enterprise Development LP

command -v yq >/dev/null 2>&1 || { echo >&2 "command not found: yq"; exit 1; }

WORKDIR="$(mktemp -d)"
trap "{ rm -rf '$WORKDIR'; }" EXIT

CONFIGDIR="$(dirname "$0")"
CHARTDIR="${CONFIGDIR}/../../kubernetes/cray-nexus-setup"

set -x

# Test airgap setup (disables S3)
#helm template "$CHARTDIR" --name cray-nexus-setup --namespace nexus --set s3.enabled=false > "${WORKDIR}/chart.yaml"

yq r "${CHARTDIR}/online-overrides.yaml" 'charts[1].values' > "${WORKDIR}/values.yaml"
helm template "$CHARTDIR" --name cray-nexus-setup --namespace nexus --set s3.enabled=false -f "${WORKDIR}/values.yaml" > "${WORKDIR}/chart.yaml"

# grab blobstore and repositories configurations
yq r -d '*' "${WORKDIR}/chart.yaml" 'data."blobstores.yaml"' > "${CONFIGDIR}/blobstores.yaml"
yq r -d '*' "${WORKDIR}/chart.yaml" 'data."repositories.yaml"' > "${CONFIGDIR}/repositories.yaml"
