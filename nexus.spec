# Copyright 2020 Hewlett Packard Enterprise Development LP
Name: cray-nexus
License: Cray Proprietary
Summary: Daemon for running the repository suite manager (Nexus)
BuildArch: x86_64
Version: 0.9.1
Release: 2.%(echo ${BUILD_METADATA})
Source: %{name}-%{version}-%{release}.tar.bz2
Vendor: Cray Inc.
BuildRequires: coreutils
BuildRequires: sed
BuildRequires: skopeo
Requires: podman
Requires: podman-cni-config
%{?systemd_ordering}

%define imagedir %{_sharedstatedir}/cray/container-images/%{name}

%define sonatype_nexus3_tag   3.25.0
%define sonatype_nexus3_image arti.dev.cray.com/third-party-docker-stable-local/sonatype/nexus3:%{sonatype_nexus3_tag}
%define sonatype_nexus3_file  sonatype-nexus3-%{sonatype_nexus3_tag}.tar

%define busybox_tag   1.31.1
%define busybox_image arti.dev.cray.com/baseos-docker-master-local/busybox:%{busybox_tag}
%define busybox_file  baseos-busybox-%{busybox_tag}.tar

%define cray_nexus_setup_tag   0.5.2
%define cray_nexus_setup_image arti.dev.cray.com/csm-docker-stable-local/cray-nexus-setup:%{cray_nexus_setup_tag}
%define cray_nexus_setup_file  cray-nexus-setup-%{cray_nexus_setup_tag}.tar

%define skopeo_image quay.io/skopeo/stable
%define skopeo_file  skopeo-stable.tar

%description
This RPM installs the daemon file for Nexus, launched through podman. This allows nexus to launch
as a systemd service on a system.

%prep
%setup -q

%build
sed -e 's,@@sonatype-nexus3-image@@,%{sonatype_nexus3_image},g' \
    -e 's,@@sonatype-nexus3-path@@,%{imagedir}/%{sonatype_nexus3_file},g' \
    -e 's,@@busybox-image@@,%{busybox_image},g' \
    -e 's,@@busybox-path@@,%{imagedir}/%{busybox_file},g' \
    -i systemd/nexus-init.sh
sed -e 's,@@cray-nexus-setup-image@@,%{cray_nexus_setup_image},g' \
    -e 's,@@cray-nexus-setup-path@@,%{imagedir}/%{cray_nexus_setup_file},g' \
    -i systemd/nexus-setup.sh
skopeo copy docker://%{sonatype_nexus3_image}  docker-archive:%{sonatype_nexus3_file}
skopeo copy docker://%{busybox_image}          docker-archive:%{busybox_file}
skopeo copy docker://%{cray_nexus_setup_image} docker-archive:%{cray_nexus_setup_file}
skopeo copy docker://%{skopeo_image}           docker-archive:%{skopeo_file}

%install
install -D -m 0644 -t %{buildroot}%{_unitdir} systemd/nexus.service
install -D -m 0755 -t %{buildroot}%{_sbindir} systemd/nexus-init.sh systemd/nexus-setup.sh
ln -s %{_sbindir}/service %{buildroot}%{_sbindir}/rcnexus
install -D -m 0644 -t %{buildroot}%{imagedir} \
    %{sonatype_nexus3_file} \
    %{busybox_file} \
    %{cray_nexus_setup_file} \
    %{skopeo_file}

%clean
rm -f \
    %{sonatype_nexus3_file} \
    %{busybox_file} \
    %{cray_nexus_setup_file} \
    %{skopeo_file}

%pre
%service_add_pre nexus.service

%post
%service_add_post nexus.service

%preun
%service_del_preun nexus.service

%postun
%service_del_postun nexus.service

%files
%doc README.md
%defattr(-,root,root)
%{_unitdir}/nexus.service
%{_sbindir}/nexus-init.sh
%{_sbindir}/nexus-setup.sh
%{_sbindir}/rcnexus
%{imagedir}/%{sonatype_nexus3_file}
%{imagedir}/%{busybox_file}
%{imagedir}/%{cray_nexus_setup_file}
%{imagedir}/%{skopeo_file}

%changelog
