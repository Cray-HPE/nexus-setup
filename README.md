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
+ ./hack/config/generate.sh
+ yq r ./hack/config/../../kubernetes/cray-nexus-setup/online-overrides.yaml 'charts[1].values'
+ helm template ./hack/config/../../kubernetes/cray-nexus-setup --name cray-nexus-setup --namespace nexus -f /var/folders/8n/f3m713z530s55v0972gcs_n4006fd2/T/tmp.xyoEBq0h/values.yaml
+ yq r -d '*' /var/folders/8n/f3m713z530s55v0972gcs_n4006fd2/T/tmp.xyoEBq0h/chart.yaml 'data."blobstores.yaml"'
+ yq r -d '*' /var/folders/8n/f3m713z530s55v0972gcs_n4006fd2/T/tmp.xyoEBq0h/chart.yaml 'data."repositories.yaml"'
+ rm -rf /var/folders/8n/f3m713z530s55v0972gcs_n4006fd2/T/tmp.xyoEBq0h
++ dirname ./hack/nexus-init
+ nexus-blobstores-create ./hack/config/blobstores.yaml
Creating file blobstore: local... 204 OK
Creating file blobstore: shasta-1.3... 204 OK
Creating file blobstore: latest... 204 OK
Creating file blobstore: dvds... 204 OK
++ dirname ./hack/nexus-init
+ nexus-repositories-create ./hack/config/repositories.yaml
Creating helm/hosted repository: default-charts...201 OK
Creating docker/hosted repository: default-registry...201 OK
Creating yum/hosted repository: default-rpms...201 OK
Creating docker/proxy repository: dtr.dev.cray.com...201 OK
Creating helm/proxy repository: helmrepo.dev.cray.com...201 OK
Creating raw/proxy repository: dvd-SLE-15-SP1-Installer-DVD-x86_64-GM-DVD1...201 OK
Creating raw/proxy repository: dvd-SLE-15-SP1-Installer-DVD-x86_64-QU2-DVD1...201 OK
Creating raw/proxy repository: dvd-SLE-15-SP1-Installer-DVD-x86_64-QU2-DVD2...201 OK
Creating raw/proxy repository: dvd-SLE-15-SP1-Packages-x86_64-GM-DVD1...201 OK
Creating raw/proxy repository: dvd-SLE-15-SP1-Packages-x86_64-QU2-DVD1...201 OK
Creating raw/proxy repository: dvd-SLE-15-SP1-Packages-x86_64-QU2-DVD2...201 OK
Creating yum/proxy repository: badger-1.3...201 OK
Creating raw/proxy repository: cos-images-1.3-sle-15sp1-compute...201 OK
Creating yum/proxy repository: cos-1.3-sle-15sp1-compute...201 OK
Creating yum/proxy repository: cos-1.3-sle-15sp1-management...201 OK
Creating yum/proxy repository: ct-tests-1.3-sle-15sp1-management...201 OK
Creating yum/proxy repository: mirror-1.3-opensuse-leap-15...201 OK
Creating yum/proxy repository: mirror-1.3-sle-15sp1-all-products...201 OK
Creating yum/proxy repository: mirror-1.3-sle-15sp1-all-updates...201 OK
Creating yum/proxy repository: pe-crayctldeploy-1.3-sle-15sp1-management...201 OK
Creating yum/proxy repository: shasta-firmware-1.3...201 OK
Creating yum/proxy repository: sma-crayctldeploy-1.3-sle-15sp1-management...201 OK
Creating yum/proxy repository: sma-1.3-sle-15sp1-compute...201 OK
Creating yum/proxy repository: sma-1.3-sle-15sp1-management...201 OK
Creating yum/proxy repository: sms-crayctldeploy-1.3-sle-15sp1-management...201 OK
Creating yum/proxy repository: thirdparty-1.3-sle-15sp1-compute...201 OK
Creating yum/proxy repository: thirdparty-1.3-sle-15sp1-management...201 OK
Creating yum/proxy repository: badger...201 OK
Creating raw/proxy repository: cos-images-sle-15sp1-compute...201 OK
Creating yum/proxy repository: cos-sle-15sp1-compute...201 OK
Creating yum/proxy repository: cos-sle-15sp1-management...201 OK
Creating yum/proxy repository: ct-tests-sle-15sp1-management...201 OK
Creating yum/proxy repository: mirror-opensuse-leap-15...201 OK
Creating yum/proxy repository: mirror-sle-15sp1-all-products...201 OK
Creating yum/proxy repository: mirror-sle-15sp1-all-updates...201 OK
Creating yum/proxy repository: pe-crayctldeploy-sle-15sp1-management...201 OK
Creating yum/proxy repository: shasta-firmware...201 OK
Creating yum/proxy repository: sma-crayctldeploy-sle-15sp1-management...201 OK
Creating yum/proxy repository: sma-sle-15sp1-compute...201 OK
Creating yum/proxy repository: sma-sle-15sp1-management...201 OK
Creating yum/proxy repository: sms-crayctldeploy-sle-15sp1-management...201 OK
Creating yum/proxy repository: thirdparty-sle-15sp1-compute...201 OK
Creating yum/proxy repository: thirdparty-sle-15sp1-management...201 OK
Creating docker/group repository: registry.local...201 OK
Creating yum/group repository: sms-1.3-sle-15sp1-management...201 OK
Creating yum/group repository: sms-sle-15sp1-management...201 OK
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

