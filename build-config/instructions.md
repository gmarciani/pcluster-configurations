```
REGION="us-east-1"
IMAGE_ID="mg3101-rocky9-x8664-1"
CONFIG="/Users/mgiacomo/workplace/aws-parallelcluster-dev/pcluster-configurations/build-config/dev/config.yaml"
PCLUSTER_VERSION="3.10.1"

pcluster build-image \
  --region $REGION \
  --image-configuration $CONFIG \
  --image-id $IMAGE_ID \
  --rollback-on-failure False \
  --dryrun True
```

```
REGION="cn-northwest-1"
IMAGE_ID="integ-tests-build-image-nps0nivx91pdb783-3-10-3-10"
PCLUSTER_VERSION="3.10.1"
watch -n 1 "pcluster get-image-log-events --region $REGION --image-id $IMAGE_ID --log-stream-name $PCLUSTER_VERSION/1 --query 'events[*].message' | tail -n 50"
```

```
pcluster list-image-log-streams \
  --region $REGION \
  --image-id $IMAGE_ID \
  --query "logStreams[0].logStreamArn"
```

```
pcluster describe-image \
--region $REGION \
--image-id $IMAGE_ID \
--query ec2AmiInfo.amiId
```


package="kernel-devel-5.14.0-362.8.1.el9_3.x86_64"
kernel_machine="x86_64"
dnf install -y ${package} --releasever 9.3

base_os_package_url="https://dl.rockylinux.org/vault/rocky/9.3/BaseOS/${kernel_machine}/os/Packages/k/${package}.rpm"
appstream_package_url="https://dl.rockylinux.org/vault/rocky/9.3/AppStream/${kernel_machine}/os/Packages/k/${package}.rpm"
curl --write-out '%{http_code}' --silent --output /dev/null ${base_os_package_url}
curl --write-out '%{http_code}' --silent --output /dev/null ${appstream_package_url}
