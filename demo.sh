#!/bin/bash

# Copyright 2020 Hewlett Packard Enterprise Development LP

NO_WAIT=${NO_WAIT:-false}

function wait(){
    if [ "$NO_WAIT" != "true" ]; then
        read -rsn1 -p"demo: Press any key to continue";echo
    fi
}

type asciinema >/dev/null 2>&1 || error "demo: asciinema is required but it's not installed. Aborting."

reset
echo >&2 "demo: Setup base SLE 15 SP1 system"
asciinema play -i 0.5 -s 1.5 casts/setup-base-sle15sp1.cast
wait

reset
echo >&2 "demo: Setup Nexus Repository Manager 3"
asciinema play -i 0.5 -s 1.5 casts/setup-nexus3.cast
wait

reset
echo >&2 "demo: Configure Nexus proxy repositories to DST master upstream repositories"
asciinema play -i 0.5 -s 1.5 casts/config-nexus3-repos.cast

echo "demo: Finished!"
