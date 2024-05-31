#!/bin/bash
set -e

# Constants to be parameterized from cluster config
DIRECTORY_DOMAIN="corp.mgiacomo3.com"
DIRECTORY_REALM="CORP.MGIACOMO3.COM"
DIRECTORY_ADMIN_NAME="Admin"
DIRECTORY_ADMIN_PASSWORD="p@ssw0rd"
DIRECTORY_IP_1="3.5.6.36"
DIRECTORY_IP_2="3.5.59.191"

echo "[INFO] Installing OS packages"
sudo yum install -y sssd realmd krb5-workstation oddjob oddjob-mkhomedir adcli sssd samba-common-tools

echo "[INFO] Joining the domain"

realm discover -v $DIRECTORY_DOMAIN
echo $DIRECTORY_ADMIN_PASSWORD | sudo realm join -v -U $DIRECTORY_ADMIN_NAME $DIRECTORY_IP_1
realm list

echo "[INFO] Configuring Kerberos client"

sudo cat >/etc/krb5.conf <<EOL
# Configuration snippets may be placed in this directory as well
includedir /etc/krb5.conf.d/

includedir /var/lib/sss/pubconf/krb5.include.d/
[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 dns_lookup_realm = false
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true
 rdns = false
 pkinit_anchors = FILE:/etc/pki/tls/certs/ca-bundle.crt
 default_ccache_name = KEYRING:persistent:%{uid}
 default_realm = ${DIRECTORY_REALM}

[realms]
 ${DIRECTORY_REALM} = {
  kdc = ${DIRECTORY_IP_1}
  kdc = ${DIRECTORY_IP_2}
  admin_server = ${DIRECTORY_IP_1}
  admin_server = ${DIRECTORY_IP_2}
 }

[domain_realm]
 ${DIRECTORY_DOMAIN} = ${DIRECTORY_REALM}
 .${DIRECTORY_DOMAIN} = ${DIRECTORY_REALM}
EOL

echo "[INFO] Restarting SSSD"

sudo service sssd restart