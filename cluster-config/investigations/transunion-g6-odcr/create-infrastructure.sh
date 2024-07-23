# Constants (replace with your values)
ACCOUNT="319414405305"
REGION="us-east-1"
AZS=(us-east-1c)
#RESOURCE_GROUP_NAME="pcluster-g4dn-8xlarge-odcr"
RESOURCE_GROUP_NAME="pcluster-g6-12xlarge-odcr"
CR_TYPES=(open targeted)
#CR_INSTANCE_TYPE="g4dn.8xlarge"
CR_INSTANCE_TYPE="g6.12xlarge"
INSTANCE_COUNT=2
#PG_NAME="pcluster-g4dn-8xlarge-pg"
PG_NAME="pcluster-g6-12xlarge-pg"


RESOURCE_GROUP_ARN=$(
  aws resource-groups create-group \
  --region $REGION \
  --name $RESOURCE_GROUP_NAME \
  --configuration '{"Type":"AWS::EC2::CapacityReservationPool"}' '{"Type":"AWS::ResourceGroups::Generic", "Parameters": [{"Name": "allowed-resource-types", "Values": ["AWS::EC2::CapacityReservation"]}]}' \
  --query "Group.GroupArn" \
  --output text
)

PG_ARN=$(
  aws ec2 create-placement-group \
  --region $REGION \
  --group-name $PG_NAME \
  --strategy cluster \
  --query "PlacementGroup.GroupArn" \
  --output text
)

PG_ARN=$(
  aws ec2 describe-placement-groups \
  --region $REGION \
  --group-names $PG_NAME \
  --filters "Name=strategy,Values=cluster" \
  --query "PlacementGroups[0].GroupArn" \
  --output text
)

for AZ in "${AZS[@]}"; do
  for CR_TYPE in "${CR_TYPES[@]}"; do
    echo "Capacity Reservation ${CR_TYPE} for instance type $CR_INSTANCE_TYPE in ${AZ}"
    PG_OPTION=$([[ "$CR_TYPE" == "targeted" ]] && echo "--placement-group-arn $PG_ARN" || echo "")
    CR_ID=$(
      aws ec2 create-capacity-reservation \
      --region $REGION \
      --instance-type $CR_INSTANCE_TYPE \
      --instance-platform Linux/UNIX \
      --availability-zone $AZ \
      --instance-count $INSTANCE_COUNT \
      --instance-match-criteria $CR_TYPE \
      --query "CapacityReservation.CapacityReservationId" \
      --output text $PG_OPTION
    )
    aws resource-groups group-resources \
    --region $REGION \
    --group $RESOURCE_GROUP_NAME \
    --resource-arns "arn:aws:ec2:${REGION}:${ACCOUNT}:capacity-reservation/${CR_ID}"
    echo "Capacity Reservation ${CR_TYPE} for instance type $CR_INSTANCE_TYPE in ${AZ} ${CR_ID} added to the group $RESOURCE_GROUP_ARN"
  done
done