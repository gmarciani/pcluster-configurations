#!/bin/bash
set -e

CURRENT_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

aws s3 sync $CURRENT_DIR s3://mgiacomo-workspace/pcluster-configurations/cluster-config/pyxis/