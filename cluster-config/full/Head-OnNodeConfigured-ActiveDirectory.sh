#!/bin/bash
set -e

CERTIFICATE_SECRET_ARN="$1"
CERTIFICATE_PATH="$2"

[[ -z $CERTIFICATE_SECRET_ARN ]] && echo "[ERROR] Missing CERTIFICATE_SECRET_ARN" && exit 1
[[ -z $CERTIFICATE_PATH ]] && echo "[ERROR] Missing CERTIFICATE_PATH" && exit 1

source /etc/parallelcluster/cfnconfig
REGION="${cfn_region:?}"

CERTIFICATE_FOLDER=$(dirname $CERTIFICATE_PATH)
mkdir -p $CERTIFICATE_FOLDER
chmod +x $CERTIFICATE_FOLDER
aws secretsmanager get-secret-value --region $REGION --secret-id $CERTIFICATE_SECRET_ARN --query SecretString --output text > $CERTIFICATE_PATH