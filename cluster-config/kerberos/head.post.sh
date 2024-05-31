#!/bin/bash
set -e

# Usage
# ./head.post.sh DIRECTORY_DOMAIN DIRECTORY_IPS DIRECTORY_ADMIN_NAME DIRECTORY_ADMIN_PASSWORD
#
# Example:
# ./head.post.sh corp.mgiacomo.com 3.5.6.36,3.5.59.191 Admin AdminPass

# Parameters
DIRECTORY_DOMAIN=${1}
DIRECTORY_IPS=${2}
DIRECTORY_ADMIN_NAME=${3}
DIRECTORY_ADMIN_PASSWORD=${4}

[[ -z ${DIRECTORY_DOMAIN} ]] && echo "[ERROR] Missing required argument: DIRECTORY_DOMAIN" && exit 1
[[ -z ${DIRECTORY_IPS} ]] && echo "[ERROR] Missing required argument: DIRECTORY_IPS" && exit 1
[[ -z ${DIRECTORY_ADMIN_NAME} ]] && echo "[ERROR] Missing required argument: DIRECTORY_ADMIN_NAME" && exit 1
[[ -z ${DIRECTORY_ADMIN_PASSWORD} ]] && echo "[ERROR] Missing required argument: DIRECTORY_ADMIN_PASSWORD" && exit 1

DIRECTORY_REALM=$(echo "$DIRECTORY_DOMAIN" | tr '[:lower:]' '[:upper:]')
DIRECTORY_DOMAIN_CN="DC=${DIRECTORY_DOMAIN//./,DC=}"
DIRECTORY_IP_1=$(echo "$DIRECTORY_IPS" | cut -d ',' -f 1)
DIRECTORY_IP_2=$(echo "$DIRECTORY_IPS" | cut -d ',' -f 2)
DIRECTORY_DOMAIN_CONTROLLER_1=$(dig @${DIRECTORY_IP_1} -x ${DIRECTORY_IP_1} +short | grep ".${DIRECTORY_DOMAIN}")
DIRECTORY_DOMAIN_CONTROLLER_1=${DIRECTORY_DOMAIN_CONTROLLER_1%.}
DIRECTORY_DOMAIN_CONTROLLER_2=$(dig @${DIRECTORY_IP_1} -x ${DIRECTORY_IP_2} +short | grep ".${DIRECTORY_DOMAIN}")
DIRECTORY_DOMAIN_CONTROLLER_2=${DIRECTORY_DOMAIN_CONTROLLER_2%.}

echo "[INFO] Installing OS packages"
sudo yum install -y sssd realmd krb5-workstation oddjob oddjob-mkhomedir adcli sssd samba-common-tools openldap-clients

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

echo "[INFO] Configuring SSSD"

sudo cat >/etc/sssd/sssd.conf <<EOL
[sssd]
domains = ${DIRECTORY_DOMAIN}
config_file_version = 2
services = nss, pam

[domain/${DIRECTORY_DOMAIN}]
ad_server = ${DIRECTORY_DOMAIN_CONTROLLER_1},${DIRECTORY_DOMAIN_CONTROLLER_2}
ad_domain = ${DIRECTORY_DOMAIN}
krb5_realm = ${DIRECTORY_REALM}
realmd_tags = manages-system joined-with-adcli
cache_credentials = False
id_provider = ad
krb5_store_password_if_offline = True
default_shell = /bin/bash
ldap_id_mapping = True
use_fully_qualified_names = False
fallback_homedir = /home/%u
access_provider = ad
# Optional
debug_level = 9
EOL

echo "[INFO] Configuring LDAP"

sudo cat >/etc/openldap/ldap.conf <<EOL

#
# LDAP Defaults
#

# See ldap.conf(5) for details
# This file should be world readable but not world writable.

BASE   ${DIRECTORY_DOMAIN_CN}
URI    ldap://${DIRECTORY_DOMAIN_CONTROLLER_1} ldap://${DIRECTORY_DOMAIN_CONTROLLER_2}

#SIZELIMIT    12
#TIMELIMIT    15
#DEREF        never

TLS_CACERTDIR    /etc/openldap/certs

# Turning this off breaks GSSAPI used with krb5 when rdns = false
SASL_NOCANON    on
EOL

echo "[INFO] Restarting SSSD"

sudo service sssd restart