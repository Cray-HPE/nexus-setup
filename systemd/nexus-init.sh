#!/bin/bash

# Copyright 2020 Hewlett Packard Enterprise Development LP

if [ $# -lt 2 ]; then
    echo >&2 "usage: nexus-init PIDFILE CIDFILE [CONTAINER [VOLUME]]"
    exit 1
fi

NEXUS_PIDFILE="$1"
NEXUS_CIDFILE="$2"
NEXUS_CONTAINER_NAME="${3-nexus}"
NEXUS_VOLUME_NAME="${4:-${NEXUS_CONTAINER_NAME}-data}"

# Using sonatype/nexus3:latest introduced an NPE issue with proxying to
# helmrepo.dev.cray.com.
NEXUS_CONTAINER_IMAGE="sonatype/nexus3:3.25.0"
NEXUS_VOLUME_MOUNT="/nexus-data:rw,exec"

command -v podman >/dev/null 2>&1 || { echo >&2 "${0##*/}: command not found: podman"; exit 1; }

set -x

# Create Nexus volume if not already present
if ! podman volume inspect "$NEXUS_VOLUME_NAME" ; then
    podman pull busybox || exit
    podman run --rm --network host \
        -v "${NEXUS_VOLUME_NAME}:${NEXUS_VOLUME_MOUNT}" \
        busybox /bin/sh -c "
mkdir -p /nexus-data/etc
cat > /nexus-data/etc/nexus.properties << EOF
nexus.onboarding.enabled=false
nexus.scripts.allowCreation=true
nexus.security.randompassword=false
EOF
chown -Rv 200:200 /nexus-data
chmod -Rv u+rwX,go+rX,go-w /nexus-data
" || exit
    podman volume inspect "$NEXUS_VOLUME_NAME" || exit
fi

# always ensure pid file is fresh
rm -f "$NEXUS_PIDFILE"

# Create Nexus container
if ! podman inspect "$NEXUS_CONTAINER_NAME" ; then
    rm -f "$NEXUS_CIDFILE" || exit
    podman pull "$NEXUS_CONTAINER_IMAGE" || exit
    podman create \
        --conmon-pidfile "$NEXUS_PIDFILE" \
        --cidfile "$NEXUS_CIDFILE" \
        --cgroups=no-conmon \
        -d \
        --network host \
        --volume "${NEXUS_VOLUME_NAME}:${NEXUS_VOLUME_MOUNT}" \
        --name "$NEXUS_CONTAINER_NAME" \
        "$NEXUS_CONTAINER_IMAGE" || exit
    podman inspect "$NEXUS_CONTAINER_NAME" || exit
fi
