Copyright 2020 Hewlett Packard Enterprise Development LP


**Warning:** These instructions are outdated and need to be updated based on
the scripts in ../bin/.

Manage Nexus as a Systemd Service
=================================

Requires podman >= 1.8.0.

1.  Copy `nexus-init.sh` to `/opt/cray/bin/nexus-init.sh` (and make sure it's
    executable)

2.  Copy `nexus.service` to `/etc/systemd/system/nexus.service`

3.  Run `systemctl daemon-reload`

4.  Run `systemctl enable nexus` so Nexus will automatically restart if the
    node is rebooted

5.  Run `systemctl start nexus` to start Nexus

If `systemctl status nexus` reports active, podman can be used to introspect
the running `nexus` container.
