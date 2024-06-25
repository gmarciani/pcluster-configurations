resource "random_uuid" "demo_id" {}

resource "pcluster_image" "demo_image" {
  image_id            = var.image_id
  image_configuration = yamlencode({
    "Build":{
      "InstanceType": var.build_instance_type,
      "ParentImage": var.parent_image,
      "SubnetId": aws_default_subnet.public_az1.id,
      "SecurityGroupIds": [aws_default_security_group.default_sg.id],
      "UpdateOsPackages": {"Enabled": false},
      "Iam": {"CleanupLambdaRole": aws_iam_role.cleanup_lambda_role.arn}
    }
  })
  rollback_on_failure = false
}