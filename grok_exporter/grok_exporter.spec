%define debug_package %{nil}

Name:    grok_exporter
Version: 0.2.3
Release: 2%{?dist}
Summary: Export Prometheus metrics from arbitrary unstructured log data.
License: ASL 2.0
URL:     https://github.com/fstab/grok_exporter

Source0: https://github.com/fstab/grok_exporter/releases/download/v%{version}/grok_exporter-%{version}.linux-amd64.zip
Source1: grok_exporter.service
Source2: grok_exporter.default

%{?systemd_requires}
Requires(pre): shadow-utils

%description

Grok is a tool to parse crappy unstructured log data into something structured and queryable. Grok is heavily used in Logstash to provide log data as input for ElasticSearch.

Grok ships with about 120 predefined patterns for syslog logs, apache and other webserver logs, mysql logs, etc. It is easy to extend Grok with custom patterns.

The grok_exporter aims at porting Grok from the ELK stack to Prometheus monitoring. The goal is to use Grok patterns for extracting Prometheus metrics from arbitrary log files.

%prep
%setup -q -n grok_exporter-%{version}.linux-amd64

%build
/bin/true

%install
mkdir -vp %{buildroot}/var/lib/prometheus
mkdir -vp %{buildroot}/usr/bin
mkdir -vp %{buildroot}/usr/lib/systemd/system
mkdir -vp %{buildroot}/etc/default
install -m 755 grok_exporter %{buildroot}/usr/bin/grok_exporter
cp -a patterns %{buildroot}/var/lib/prometheus
install -m 644 %{SOURCE1} %{buildroot}/usr/lib/systemd/system/grok_exporter.service
install -m 644 %{SOURCE2} %{buildroot}/etc/default/grok_exporter

%pre
getent group prometheus >/dev/null || groupadd -r prometheus
getent passwd prometheus >/dev/null || \
  useradd -r -g prometheus -d /var/lib/prometheus -s /sbin/nologin \
          -c "Prometheus services" prometheus
exit 0

%post
%systemd_post grok_exporter.service

%preun
%systemd_preun grok_exporter.service

%postun
%systemd_postun grok_exporter.service

%files
%defattr(-,root,root,-)
/usr/bin/grok_exporter
/usr/lib/systemd/system/grok_exporter.service
%config(noreplace) /etc/default/grok_exporter
%attr(755, prometheus, prometheus)/var/lib/prometheus
