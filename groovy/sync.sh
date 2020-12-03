#!/bin/bash

# Copyright 2020 Hewlett Packard Enterprise Development LP

# Syncs useful groovy scripts from the upstream Ansible library for setting up
# Nexus. These scripts are required to address gaps in the REST API.

set -e

# See https://github.com/ansible-ThoTeam/nexus3-oss/blob/master/files/groovy/
fetch() {
    for filename in "$@"; do
        curl -sfL "https://raw.githubusercontent.com/ansible-ThoTeam/nexus3-oss/master/files/groovy/${filename}.groovy" > "${filename}.groovy"
    done
}

fetch \
    setup_anonymous_access \
    setup_capability \
    create_task

