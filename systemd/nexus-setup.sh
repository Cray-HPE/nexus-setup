#!/bin/bash

# Copyright 2020 Hewlett Packard Enterprise Development LP

NEXUS_SETUP_CONTAINER_IMAGE="dtr.dev.cray.com/cray/cray-nexus-setup:latest"

command -v podman >/dev/null 2>&1 || { echo >&2 "${0##*/}: command not found: podman"; exit 1; }

set -x

podman pull "$NEXUS_SETUP_CONTAINER_IMAGE" || exit

# Setup Nexus container (assumes Nexus is at http://localhost:8081)
podman run --rm --network host \
    "$NEXUS_SETUP_CONTAINER_IMAGE" \
    /bin/sh -c "
while ! nexus-ready; do
  echo >&2 'Waiting for nexus to be ready, trying again in 10 seconds'
  sleep 10
done

# If the script already exists, Nexus API reports failure :-(
nexus-upload-script /usr/local/share/nexus-setup/groovy/*.groovy >&2

nexus-enable-anonymous-access >&2
nexus-remove-default-repos >&2

cat > /tmp/nexus-repositories.yaml << EOF
---
cleanup: null
docker:
  forceBasicAuth: false
  httpPort: 5000
  httpsPort: null
  v1Enabled: false
dockerProxy:
  indexType: HUB
  indexUrl: null
format: docker
httpClient:
  authentication: null
  autoBlock: false
  blocked: false
  connection:
    retries: 5
    userAgentSuffix: null
    timeout: 300
    enableCircularRedirects: false
    enableCookies: false
name: dtr.dev.cray.com
negativeCache:
  enabled: false
  timeToLive: 0
online: true
proxy:
  contentMaxAge: 1440
  metadataMaxAge: 1
  remoteUrl: https://dtr.dev.cray.com/
routingRule: null
storage:
  blobStoreName: default
  strictContentTypeValidation: false
  writePolicy: ALLOW
type: proxy
---
cleanup: null
format: raw
httpClient:
  authentication: null
  autoBlock: false
  blocked: false
  connection:
    retries: 5
    userAgentSuffix: null
    timeout: 300
    enableCircularRedirects: false
    enableCookies: false
name: helmrepo.dev.cray.com
negativeCache:
  enabled: false
  timeToLive: 0
online: true
proxy:
  contentMaxAge: 1440
  metadataMaxAge: 1
  remoteUrl: http://helmrepo.dev.cray.com:8080/
routingRule: null
storage:
  blobStoreName: default
  strictContentTypeValidation: false
type: proxy
EOF

nexus-repositories-create /tmp/nexus-repositories.yaml >&2
nexus-enable-docker-realm >&2
" || exit
