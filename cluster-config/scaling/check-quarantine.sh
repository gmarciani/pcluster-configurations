#!/bin/bash

REGION="eu-west-1"
LAUNCH_TIME="2023-08-01T10:4*Z"
CLUSTER_NAME="scaling370-0801-cw1"
#CLUSTER_NAME="scaling370-0801-nocw1"

echo "--- COOKBOOK-FAILURE ---"
aws ec2 describe-instances \
--region $REGION \
--filter "Name=tag:parallelcluster:cluster-name,Values=$CLUSTER_NAME" "Name=tag:QUARANTINE-REASON,Values=COOKBOOK-FAILURE" "Name=launch-time,Values=$LAUNCH_TIME" \
--query "Reservations[].Instances[].InstanceId" \
--output text

echo "--- COOKBOOK-TIMEOUT ---"
aws ec2 describe-instances \
--region $REGION \
--filter "Name=tag:parallelcluster:cluster-name,Values=$CLUSTER_NAME" "Name=tag:QUARANTINE-REASON,Values=COOKBOOK-TIMEOUT" "Name=launch-time,Values=$LAUNCH_TIME" \
--query "Reservations[].Instances[].InstanceId" \
--output text

echo "--- TerminatedBySlurm:_terminate_orphaned_instances ---"
aws ec2 describe-instances \
--region $REGION \
--filter "Name=tag:parallelcluster:cluster-name,Values=$CLUSTER_NAME" "Name=tag:QUARANTINE-REASON,Values=TerminatedBySlurm:_terminate_orphaned_instances" "Name=launch-time,Values=$LAUNCH_TIME" \
--query "Reservations[].Instances[].InstanceId" \
--output text

echo "--- TerminatedBySlurm:_handle_powering_down_nodes ---"
aws ec2 describe-instances \
--region $REGION \
--filter "Name=tag:parallelcluster:cluster-name,Values=$CLUSTER_NAME" "Name=tag:QUARANTINE-REASON,Values=TerminatedBySlurm:_handle_powering_down_nodes" "Name=launch-time,Values=$LAUNCH_TIME" \
--query "Reservations[].Instances[].InstanceId" \
--output text

echo "--- TerminatedBySlurm:_handle_unhealthy_dynamic_nodes ---"
aws ec2 describe-instances \
--region $REGION \
--filter "Name=tag:parallelcluster:cluster-name,Values=$CLUSTER_NAME" "Name=tag:QUARANTINE-REASON,Values=TerminatedBySlurm:_handle_unhealthy_dynamic_nodes" "Name=launch-time,Values=$LAUNCH_TIME" \
--query "Reservations[].Instances[].InstanceId" \
--output text