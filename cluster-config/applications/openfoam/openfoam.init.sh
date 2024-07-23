#!/bin/bash
set -ex

TARGET_USER=$(whoami)

SHARED_DIR="/shared"
TARGET_USER_DIR="${SHARED_DIR}/${TARGET_USER}"

mkdir -p "${TARGET_USER_DIR}"
OLD_PWD=$(pwd)
cd "${TARGET_USER_DIR}"

SUBSPACE_BENCHMARKS_PACKAGE_S3="s3://aws-parallelcluster-mgiacomo/workloads/subspace/SubspaceBenchmarks.tar"
SUBSPACE_BENCHMARKS_PACKAGE_ZIP="${TARGET_USER_DIR}/SubspaceBenchmarks.tar"

# Retrieve the pre-signed url by running: aws s3 --region us-east-1 presign s3://aws-parallelcluster-mgiacomo/workloads/subspace/SubspaceBenchmarks.tar --expires-in 604800
#SUBSPACE_BENCHMARKS_PACKAGE_S3_PRESIGNED_URL="https://aws-parallelcluster-mgiacomo.s3.us-east-1.amazonaws.com/workloads/subspace/SubspaceBenchmarks.tar?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAUUXUVBC4TVRSE2PJ%2F20220322%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20220322T204158Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=ba3310a37d06441588cb09d71428b037da0296bdbb5d8159d9b3810836ff4f8f"
#wget -O "${SUBSPACE_BENCHMARKS_PACKAGE_ZIP}" "${SUBSPACE_BENCHMARKS_PACKAGE_S3_PRESIGNED_URL}"

aws s3 cp ${SUBSPACE_BENCHMARKS_PACKAGE_S3} ${SUBSPACE_BENCHMARKS_PACKAGE_ZIP}
tar -xf $(basename ${SUBSPACE_BENCHMARKS_PACKAGE_ZIP})

rm -rf ${SUBSPACE_BENCHMARKS_PACKAGE_ZIP}

cd ${OLD_PWD}