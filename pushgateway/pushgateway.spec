%define debug_package %{nil}

Name:    pushgateway
Version: 0.4.0
Release: 2%{?dist}
Summary: Push acceptor for ephemeral and batch jobs
License: ASL 2.0
URL:     https://github.com/prometheus/pushgateway
Source0: https://github.com/prometheus/pushgateway/releases/download/v%{version}/pushgateway-%{version}.linux-amd64.tar.gz
Source1: pushgateway.service
Source2: pushgateway.default

%{?systemd_requires}
Requires(pre): shadow-utils

%description

Push acceptor for ephemeral and batch jobs

%prep
%setup -q -n pushgateway-%{version}.linux-amd64

%build
/bin/true

%install
mkdir -vp %{buildroot}/var/lib/prometheus
mkdir -vp %{buildroot}/usr/bin
mkdir -vp %{buildroot}/usr/lib/systemd/system
mkdir -vp %{buildroot}/etc/default
install -m 755 pushgateway %{buildroot}/usr/bin/pushgateway
install -m 644 %{SOURCE1} %{buildroot}/usr/lib/systemd/system/pushgateway.service
install -m 644 %{SOURCE2} %{buildroot}/etc/default/pushgateway

%pre
getent group prometheus >/dev/null || groupadd -r prometheus
getent passwd prometheus >/dev/null || \
  useradd -r -g prometheus -d /var/lib/prometheus -s /sbin/nologin \
          -c "Prometheus services" prometheus
exit 0

%post
%systemd_post pushgateway.service

%preun
%systemd_preun pushgateway.service

%postun
%systemd_postun pushgateway.service

%files
%defattr(-,root,root,-)
/usr/bin/pushgateway
/usr/lib/systemd/system/pushgateway.service
%config(noreplace) /etc/default/pushgateway
%attr(755, prometheus, prometheus)/var/lib/prometheus
