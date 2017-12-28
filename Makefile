PACKAGES = prometheus \
alertmanager \
node_exporter \
haproxy_exporter \
mysqld_exporter \
pushgateway \
kafka_consumer_group_exporter \
snmp_exporter \
blackbox_exporter \
grok_exporter

NEXUS_URL = http://admin:admin123@sjc-engfrslv-08.eng.ssnsgs.net:8081/content/repositories/slv-rpm

.PHONY: $(PACKAGES) jmx_exporter

all: $(PACKAGES)

$(PACKAGES):
	docker run --rm \
		-v ${PWD}/$@:/rpmbuild/SOURCES \
		-v ${PWD}/_dist:/rpmbuild/RPMS/x86_64 \
		lest/centos7-rpm-builder \
		build-spec SOURCES/$@.spec

jmx_exporter:
	cd jmx_exporter && mvn package && mvn deploy:deploy-file \
		-DgroupId=thirdparty \
		-DartifactId=jmx_exporter \
		-Dversion=1.0 \
		-DrepositoryId=nexus \
		-Durl=${NEXUS_URL} \
		-Dfile=${PWD}/$@/jmx_prometheus_httpserver/target/jmx_prometheus_httpserver-0.1.0-jar-with-dependencies.jar

jmx_prometheus_javaagent:
	mvn deploy:deploy-file \
		-DgroupId=thirdparty \
		-DartifactId=jmx_prometheus_javaagent \
		-Dversion=0.1.0 \
		-DrepositoryId=nexus \
		-Durl=${NEXUS_URL} \
		-Dfile=${PWD}/_dist/jmx_prometheus_javaagent-0.1.0.jar

publish:
	mvn deploy:deploy-file \
		-DgroupId=thirdparty \
		-DartifactId=prometheus \
		-Dversion=2.0.0 \
		-DgeneratePom=true \
		-Dpackaging=rpm \
		-DrepositoryId=nexus \
		-Durl=${NEXUS_URL} \
		-Dfile=${PWD}/_dist/prometheus-2.0.0-2.el7.centos.x86_64.rpm
	# mvn deploy:deploy-file \
	# 	-DgroupId=thirdparty \
	# 	-DartifactId=node_exporter \
	# 	-Dversion=0.15.2 \
	# 	-DgeneratePom=true \
	# 	-Dpackaging=rpm \
	# 	-DrepositoryId=nexus \
	# 	-Durl=${NEXUS_URL} \
	# 	-Dfile=${PWD}/_dist/node_exporter-0.15.2-2.el7.centos.x86_64.rpm
	# mvn deploy:deploy-file \
	# 	-DgroupId=thirdparty \
	# 	-DartifactId=alertmanager \
	# 	-Dversion=0.7.1 \
	# 	-DgeneratePom=true \
	# 	-Dpackaging=rpm \
	# 	-DrepositoryId=nexus \
	# 	-Durl=${NEXUS_URL} \
	# 	-Dfile=${PWD}/_dist/alertmanager-0.7.1-1.el7.centos.x86_64.rpm
	# mvn deploy:deploy-file \
	# 	-DgroupId=thirdparty \
	# 	-DartifactId=mysqld_exporter \
	# 	-Dversion=0.10.0 \
	# 	-DgeneratePom=true \
	# 	-Dpackaging=rpm \
	# 	-DrepositoryId=nexus \
	# 	-Durl=${NEXUS_URL} \
	# 	-Dfile=${PWD}/_dist/mysqld_exporter-0.10.0-2.el7.centos.x86_64.rpm
	# mvn deploy:deploy-file \
	# 	-DgroupId=thirdparty \
	# 	-DartifactId=graphite_exporter \
	# 	-Dversion=0.1 \
	# 	-DgeneratePom=true \
	# 	-Dpackaging=rpm \
	# 	-DrepositoryId=nexus \
	# 	-Durl=${NEXUS_URL} \
	# 	-Dfile=${PWD}/_dist/graphite_exporter-0.1.0-2.el7.centos.x86_64.rpm
	# mvn deploy:deploy-file \
	# 	-DgroupId=thirdparty \
	# 	-DartifactId=collectd_exporter \
	# 	-Dversion=0.3.1 \
	# 	-DgeneratePom=true \
	# 	-Dpackaging=rpm \
	# 	-DrepositoryId=nexus \
	# 	-Durl=${NEXUS_URL} \
	# 	-Dfile=${PWD}/_dist/collectd_exporter-0.3.1-2.el7.centos.x86_64.rpm
	# mvn deploy:deploy-file \
	# 	-DgroupId=thirdparty \
	# 	-DartifactId=pushgateway \
	# 	-Dversion=0.4.0 \
	# 	-DgeneratePom=true \
	# 	-Dpackaging=rpm \
	# 	-DrepositoryId=nexus \
	# 	-Durl=${NEXUS_URL} \
	# 	-Dfile=${PWD}/_dist/pushgateway-0.4.0-2.el7.centos.x86_64.rpm
	# mvn deploy:deploy-file \
	# 	-DgroupId=thirdparty \
	# 	-DartifactId=haproxy_exporter \
	# 	-Dversion=0.8.0 \
	# 	-DgeneratePom=true \
	# 	-Dpackaging=rpm \
	# 	-DrepositoryId=nexus \
	# 	-Durl=${NEXUS_URL} \
	# 	-Dfile=${PWD}/_dist/haproxy_exporter-0.8.0-2.el7.centos.x86_64.rpm
	# mvn deploy:deploy-file \
	# 	-DgroupId=thirdparty \
	# 	-DartifactId=kafka_consumer_group_exporter \
	# 	-Dversion=0.0.6 \
	# 	-DgeneratePom=true \
	# 	-Dpackaging=rpm \
	# 	-DrepositoryId=nexus \
	# 	-Durl=${NEXUS_URL} \
	# 	-Dfile=${PWD}/_dist/kafka_consumer_group_exporter-0.0.6-1.el7.centos.x86_64.rpm
	# mvn deploy:deploy-file \
	# 	-DgroupId=thirdparty \
	# 	-DartifactId=snmp_exporter \
	# 	-Dversion=0.8.0 \
	# 	-DgeneratePom=true \
	# 	-Dpackaging=rpm \
	# 	-DrepositoryId=nexus \
	# 	-Durl=${NEXUS_URL} \
	# 	-Dfile=${PWD}/_dist/snmp_exporter-0.8.0-2.el7.centos.x86_64.rpm
	# mvn deploy:deploy-file \
	# 	-DgroupId=thirdparty \
	# 	-DartifactId=blackbox_exporter \
	# 	-Dversion=0.7.0 \
	# 	-DgeneratePom=true \
	# 	-Dpackaging=rpm \
	# 	-DrepositoryId=nexus \
	# 	-Durl=${NEXUS_URL} \
	# 	-Dfile=${PWD}/_dist/blackbox_exporter-0.7.0-2.el7.centos.x86_64.rpm

clean:
	rm -rf _dist
	rm **/*.tar.gz

