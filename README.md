# Prometheus RPM Packages

The repository contains the files needed to build [Prometheus][1] RPM packages
for CentOS 7.

The packages are available in [the SLV nexus repository][2] and can be used
by adding the following `/etc/yum.repos.d/prometheus.repo`:

``` conf
[prometheus]
name=prometheus
baseurl=http://sjc-engfrslv-08.eng.ssnsgs.net:8081/content/repositories/slv-rpm
repo_gpgcheck=0
enabled=1
gpgcheck=0
sslverify=0
metadata_expire=300
```

## Build RPMs manually

Build all packages with:

``` shell
make all
```

or build a single package only, e.g.:

``` shell
make node_exporter
```

The resulting RPMs will be created in the `_dist` directory.

[1]: https://prometheus.io
[2]: http://sjc-engfrslv-08.eng.ssnsgs.net:8081/#view-repositories;slv-rpm~browseindex
