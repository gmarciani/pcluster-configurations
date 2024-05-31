REGION="eu-west-1"
VPC_ID="vpc-05ec963dc8f4636dc"
SUBNET_ID="subnet-0b4cfba344624eb40" # DUB2/Private
BUCKET_NAME="pcluster-test-fsx-file-cache"
S3_CACHE_PATH="/fsx-cache/s3/$BUCKET_NAME/"
S3_PATH="s3://$BUCKET_NAME/data/"

#VPC_CIDR=$(aws ec2 describe-vpcs \
#--region $REGION \
#--vpc-ids $VPC_ID \
#--query "Vpcs[0].CidrBlock" \
#--output text
#)

#SG_ID=$(aws ec2 create-security-group \
#--region $REGION \
#--group-name "fsx-file-cache-sg" \
#--description "FSx File Cache Security Group" \
#--vpc-id $VPC_ID \
#--query "GroupId" \
#--output text
#)
SG_ID="sg-036dd7b59c2ea1ba0"

#aws ec2 authorize-security-group-ingress \
#--region $REGION \
#--group-id $SG_ID \
#--protocol "tcp" \
#--port 988 \
#--cidr $VPC_CIDR

#aws s3api create-bucket \
#--region $REGION \
#--bucket $BUCKET_NAME \
#--create-bucket-configuration LocationConstraint=$REGION

#echo "Hello World" > test.txt
#aws s3api put-object \
#--region $REGION \
#--bucket $BUCKET_NAME \
#--key "data/test.txt" \
#--body test.txt

aws fsx create-file-cache \
--region $REGION \
--file-cache-type LUSTRE \
--file-cache-type-version 2.12 \
--storage-capacity 1200 \
--subnet-ids $SUBNET_ID \
--security-group-ids $SG_ID \
--lustre-configuration "PerUnitStorageThroughput=1000,DeploymentType=CACHE_1,MetadataConfiguration={StorageCapacity=2400}" \
--data-repository-associations "FileCachePath=$S3_CACHE_PATH,DataRepositoryPath=$S3_PATH"