#!/bin/bash
set -e

CERTIFICATE_SECRET_ARN="$1"
CERTIFICATE_PATH="$2"

[[ -z $CERTIFICATE_SECRET_ARN ]] && echo "[ERROR] Missing CERTIFICATE_SECRET_ARN" && exit 1
[[ -z $CERTIFICATE_PATH ]] && echo "[ERROR] Missing CERTIFICATE_PATH" && exit 1

source /etc/parallelcluster/cfnconfig
REGION="${cfn_region:?}"

echo "[INFO] Reading certificate from AWS: ${CERTIFICATE_SECRET_ARN}"
service=$(echo "${CERTIFICATE_SECRET_ARN}" | cut -d ':' -f 3)
resource=$(echo "${CERTIFICATE_SECRET_ARN}" | cut -d ':' -f 6-)
if [ "$service" == "secretsmanager" ]; then
  echo "[INFO] Reading certificate as a secret from AWS Secrets Manager: ${CERTIFICATE_SECRET_ARN}"
  certificate_from_secret_store=$(aws secretsmanager get-secret-value --secret-id "${CERTIFICATE_SECRET_ARN}" --region "${REGION}" --query "SecretString" --output text)
elif [ "$service" == "ssm" ]; then
  echo "[INFO] Reading certificate as a parameter from AWS SSM: ${CERTIFICATE_SECRET_ARN}"
  parameter_name=$(echo "$resource" | cut -d '/' -f 2)
  certificate_from_secret_store=$(aws ssm get-parameter --name "${parameter_name}" --region "${REGION}" --with-decryption --query "Parameter.Value" --output text)
else
  echo "[ERROR] The secret ${CERTIFICATE_SECRET_ARN} is not supported"
  exit 1
fi

CERTIFICATE_FOLDER=$(dirname $CERTIFICATE_PATH)
mkdir -p "$CERTIFICATE_FOLDER"
chmod +x "$CERTIFICATE_FOLDER"
echo "$certificate_from_secret_store" > "$CERTIFICATE_PATH"