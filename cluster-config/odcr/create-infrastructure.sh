# Constants (replace with yopur values)
ACCOUNT="319414405305"
REGION="eu-west-1"
AZS=(eu-west-1a eu-west-1b)
RESOURCE_GROUP_NAME="pcluster-adc-odcr"
CR_TYPES=(open targeted)
CR_INSTANCE_TYPE="r5.xlarge"

RESOURCE_GROUP_ARN=$(
  aws resource-groups create-group \
  --region $REGION \
  --name $RESOURCE_GROUP_NAME \
  --configuration '{"Type":"AWS::EC2::CapacityReservationPool"}' '{"Type":"AWS::ResourceGroups::Generic", "Parameters": [{"Name": "allowed-resource-types", "Values": ["AWS::EC2::CapacityReservation"]}]}' \
  --query "Group.GroupArn" \
  --output text
)

for AZ in "$AZS[@]"; do
  for CR_TYPE in "$CR_TYPES[@]"; do
    echo "Creating Capacity Reservation in $AZ $CR_TYPE"
    CR_ID=$(
      aws ec2 create-capacity-reservation \
      --region $REGION \
      --instance-type $CR_INSTANCE_TYPE \
      --instance-platform Linux/UNIX \
      --availability-zone $AZ \
      --instance-count 4 \
      --instance-match-criteria $CR_TYPE \
      --query "CapacityReservation.CapacityReservationId" \
      --output text
    )
    aws resource-groups group-resources \
    --region $REGION \
    --group $RESOURCE_GROUP_NAME \
    --resource-arns "arn:aws:ec2:${REGION}:${ACCOUNT}:capacity-reservation/${CR_ID}"
    echo "Capacity Reservation ${CR_TYPE} in ${AZ} ${CR_ID} added to the group $RESOURCE_GROUP_ARN"
  done
done