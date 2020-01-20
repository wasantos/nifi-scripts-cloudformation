#!/bin/bash
# Gerando certificados
echo "export NIFI_FQDN_HOSTNAME=`hostname`" >> /etc/environment
source /etc/environment
mkdir /opt/cert; cd /opt/cert
/opt/nifi/toolkit/bin/tls-toolkit.sh standalone --hostnames $NIFI_FQDN_HOSTNAME --isOverwrite --keyStoreType jks
/opt/nifi/toolkit/bin/tls-toolkit.sh standalone --isOverwrite --clientCertDn CN=nifi-admin,OU=NIFI
chmod -R 777 /opt/cert
mv /opt/nifi/conf/nifi.properties /opt/nifi/conf/nifi.properties_old
mv /opt/nifi/conf/authorizers.xml /opt/nifi/conf/authorizers.xml_old
cp /opt/cert/nifi-key.key /opt/nifi/conf/
cp /opt/cert/nifi-cert.pem /opt/nifi/conf/
cp /opt/cert/CN=nifi-admin_OU=NIFI.* /opt/nifi/conf/
cd /opt/cert/$NIFI_FQDN_HOSTNAME
cp * /opt/nifi/conf/
cp /script-nifi/authorizers.xml /opt/nifi/conf/authorizers.xml
# Parar o NiFi
/opt/nifi/bin/nifi.sh stop
# Iniciar o NiFi
/opt/nifi/bin/nifi.sh start
## Change to the dir where the script is located and
# get the full name into a variable
cd "$(dirname $0)"
WORK_DIR="$(pwd)"

