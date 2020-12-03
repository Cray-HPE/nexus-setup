# Copyright 2020 Hewlett Packard Enterprise Development LP
Name: nexus
License: Cray Proprietary
Summary: Daemon for running the repository suite manager (Nexus)
BuildArchitectures: noarch
Version: %(cat .version)
Release: 1.%(echo ${BUILD_METADATA})
Source: %{name}-%{version}-%{release}.tar.bz2
Vendor: Cray Inc.
Requires: podman
%{?systemd_ordering}

%description
This RPM installs the daemon file for Nexus, launched through podman. This allows nexus to launch
as a systemd service on a system.

%prep
%setup -q

%build

%install
install -D -m 0644 systemd/%{name}.service %{buildroot}%{_unitdir}/%{name}.service
mkdir -pv %{buildroot}%{_sbindir}
install -D -m 0755 systemd/%{name}-init.sh %{buildroot}%{_sbindir}/%{name}-init.sh
install -D -m 0755 systemd/%{name}-setup.sh %{buildroot}%{_sbindir}/%{name}-setup.sh
ln -s %{_sbindir}/service %{buildroot}%{_sbindir}/rc%{name}

%clean

%pre
%service_add_pre %{name}.service

%post
%service_add_post %{name}.service

%preun
%service_del_preun %{name}.service

%postun
%service_del_postun %{name}.service

%files
%doc README.md
%defattr(-,root,root)
%{_unitdir}/%{name}.service
%{_sbindir}/%{name}-init.sh
%{_sbindir}/%{name}-setup.sh
%{_sbindir}/rc%{name}

%changelog
