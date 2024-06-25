set -ex

CURRENT_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

rm -rf $CURRENT_DIR/.terraform
rm -rf $CURRENT_DIR/.terraform.lock.hcl
rm -rf $CURRENT_DIR/.terraform.tfstate.lock.info
rm -rf $CURRENT_DIR/terraform.tfstate
rm -rf $CURRENT_DIR/terraform.tfstate.backup
rm -rf $CURRENT_DIR/tfplan