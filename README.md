Copyright 2020 Hewlett Packard Enterprise Development LP


Nexus Setup
===========


Getting Started
---------------

The `hack/` directory includes tooling to setup and configure a local Nexus
instance using docker.  Use `nexus-create` to create a new Nexus instance. By
default it creates the `nexus-data` volume and `nexus` container. (Although
`nexus-create` uses docker, it should be straight-forward to switch it to
podman if desired. See the notes below about using podman.)

```
$ ./hack/nexus-create
initializing volume: nexus-data
changed ownership of '/nexus-data/etc/nexus.properties' to 200:200
changed ownership of '/nexus-data/etc' to 200:200
changed ownership of '/nexus-data' to 200:200
mode of '/nexus-data' changed to 0755 (rwxr-xr-x)
mode of '/nexus-data/etc' changed to 0755 (rwxr-xr-x)
mode of '/nexus-data/etc/nexus.properties' changed to 0644 (rw-r--r--)
251d45ed054a0a5481ab03b28a51e96d2d2a8c3be6b65c0dcb8852d025d4bf87
Starting..........OK
```

Use `nexus-init` to configure Nexus and setup blobstores and repositories. By
default it deploys an online configuration where repositories are proxied to
upstream remotes. Modify `nexus-init` to meet your needs. The `NEXUS_URL`
environment variable controls which Nexus instance is initialized; it defaults
to `http://admin:admin123@localhost:8081`.

```
$ ./hack/nexus-init
+ nexus-ready
+ set -e
++ dirname ./hack/nexus-init
+ nexus-upload-script ./hack/../groovy/setup_anonymous_access.groovy ./hack/../groovy/setup_capability.groovy
uploading script: setup_anonymous_access...204 OK
uploading script: setup_capability...204 OK
+ nexus-enable-anonymous-access
Enable annonymous access...{
  "name" : "setup_anonymous_access",
  "result" : "OrientAnonymousConfiguration{enabled=true, userId='anonymous', realmName='NexusAuthorizingRealm'}"
}200 OK
+ nexus-remove-default-repos
Removing repository nuget-group...204 OK
Removing repository maven-snapshots...204 OK
Removing repository maven-central...204 OK
Removing repository nuget.org-proxy...204 OK
Removing repository maven-releases...204 OK
Removing repository nuget-hosted...204 OK
Removing repository maven-public...204 OK
+ nexus-enable-docker-realm
Enable Docker security realm...204 OK
+ nexus-enable-rut-auth
Enable Rut Auth...{
  "name" : "setup_capability",
  "result" : "null"
}200 OK
++ dirname ./hack/nexus-init
+ rm -rf /var/folders/8n/f3m713z530s55v0972gcs_n4006fd2/T/tmp.xyoEBq0h
```

Open http://localhost:8081 and sign in with username `admin` and password
`admin123` to manage repositories. Use client tools to interact with
repositories. For example, use `skopeo` to pull an image through the
dtr.dev.cray.com registry proxy and push it to the local-registry:

```
$ skopeo copy \
  --src-tls-verify=false \
  --dest-tls-verify=false \
  --dest-creds admin:admin123 \
  docker://localhost:5000/baseos/busybox:1 \
  docker://localhost:5003/baseos/busybox:1
Getting image source signatures
Copying blob 0669b0daf1fb done  
Copying config 12dab88b16 done  
Writing manifest to image destination
Storing signatures
```

To cleanup and delete the `nexus` container and `nexus-data` volume:

```
$ ./hack/nexus-delete
removed container: nexus
removed volume: nexus-data
```


### Using podman

Podman >= 1.8.0 is required for running sonatype/nexus3:3.25.0. It is available
in the SLE 15sp1 updates repository, e.g.,

```
ncn-w001:~ # zypper ar -cf -G http://dst.us.cray.com/dstrepo/shasta-cd-master/repos/sles/15sp1-all/Updates/ sles-15sp1-updates
ncn-w001:~ # zypper ref
ncn-w001:~ # zypper install podman
ncn-w001:~ # podman version
Version:            1.8.0
RemoteAPI Version:  1
Go Version:         go1.12.12
OS/Arch:            linux/amd64
```

#### Mounting Nexus data volume

When mounting Nexus' data volume, be sure to use the `exec` flag, e.g. `podman
run --volume nexus-data:/nexus-data:rw,exec`, otherwise Nexus will not start.

