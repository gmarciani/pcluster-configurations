```
REGION="us-east-1"
IMAGE_ID="mg310-bi-10-nosubnet"
CONFIG="/Users/mgiacomo/workplace/aws-parallelcluster-dev/pcluster-configurations/build-config/dev/config.yaml"
PCLUSTER_VERSION="3.10.0"

pcluster build-image \
  --region $REGION \
  --image-configuration $CONFIG \
  --image-id $IMAGE_ID \
  --rollback-on-failure False
```

```
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