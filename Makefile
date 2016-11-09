PACKAGES = prometheus \
alertmanager \
node_exporter \
mysqld_exporter \
blackbox_exporter

NEXUS_URL = http://admin:admin123@sjc-engfrslv-08.eng.ssnsgs.net:8081/content/repositories/slv-rpm

.PHONY: $(PACKAGES)

all: $(PACKAGES)

$(PACKAGES):
	docker run --rm \
		-v ${PWD}/$@:/rpmbuild/SOURCES \
		-v ${PWD}/_dist:/rpmbuild/RPMS/x86_64 \
		lest/centos7-rpm-builder \
		build-spec SOURCES/$@.spec

publish:
	mvn deploy:deploy-file \
		-DgroupId=com.slv \
		-DartifactId=slv-prometheus \
		-Dversion=1.3.1 \
		-DgeneratePom=true \
		-Dpackaging=rpm \
		-DrepositoryId=nexus \
		-Durl=${NEXUS_URL} \
		-Dfile=${PWD}/_dist/prometheus-1.3.1-1.el7.centos.x86_64.rpm
	mvn deploy:deploy-file \
		-DgroupId=com.slv \
		-DartifactId=slv-node_exporter \
		-Dversion=0.12 \
		-DgeneratePom=true \
		-Dpackaging=rpm \
		-DrepositoryId=nexus \
		-Durl=${NEXUS_URL} \
		-Dfile=${PWD}/_dist/node_exporter-0.12.0-2.el7.centos.x86_64.rpm
	mvn deploy:deploy-file \
		-DgroupId=com.slv \
		-DartifactId=slv-alertmanager \
		-Dversion=0.5 \
		-DgeneratePom=true \
		-Dpackaging=rpm \
		-DrepositoryId=nexus \
		-Durl=${NEXUS_URL} \
		-Dfile=${PWD}/_dist/alertmanager-0.5.0-1.el7.centos.x86_64.rpm
	mvn deploy:deploy-file \
		-DgroupId=com.slv \
		-DartifactId=slv-mysqld_exporter \
		-Dversion=0.9 \
		-DgeneratePom=true \
		-Dpackaging=rpm \
		-DrepositoryId=nexus \
		-Durl=${NEXUS_URL} \
		-Dfile=${PWD}/_dist/mysqld_exporter-0.9.0-2.el7.centos.x86_64.rpm

clean:
	rm -rf _dist
	rm **/*.tar.gz

