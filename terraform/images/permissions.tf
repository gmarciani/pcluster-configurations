data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

resource "aws_iam_role" "cleanup_lambda_role" {
  name = "CleanupLambdaRole-${random_uuid.demo_id.result}"
  path = "/parallelcluster/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "cleanup_lambda_policy" {
  name = "CleanupLambdaPolicy-${random_uuid.demo_id.result}"
  path = "/parallelcluster/"
  policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": [
            "iam:DetachRolePolicy",
            "iam:DeleteRole",
            "iam:DeleteRolePolicy"
          ],
          "Resource": "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/parallelcluster/*",
          "Effect": "Allow"
        },
        {
          "Action": [
            "iam:DeleteInstanceProfile",
            "iam:RemoveRoleFromInstanceProfile"
          ],
          "Resource": "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:instance-profile/parallelcluster/*",
          "Effect": "Allow"
        },
        {
          "Action": "imagebuilder:DeleteInfrastructureConfiguration",
          "Resource": "arn:${data.aws_partition.current.partition}:imagebuilder:${var.region}:${data.aws_caller_identity.current.account_id}:infrastructure-configuration/parallelclusterimage-*",
          "Effect": "Allow"
        },
        {
          "Action": [
            "imagebuilder:DeleteComponent"
          ],
          "Resource": [
            "arn:${data.aws_partition.current.partition}:imagebuilder:${var.region}:${data.aws_caller_identity.current.account_id}:component/parallelclusterimage-*/*"
          ],
          "Effect": "Allow"
        },
        {
          "Action": "imagebuilder:DeleteImageRecipe",
          "Resource": "arn:${data.aws_partition.current.partition}:imagebuilder:${var.region}:${data.aws_caller_identity.current.account_id}:image-recipe/parallelclusterimage-*/*",
          "Effect": "Allow"
        },
        {
          "Action": "imagebuilder:DeleteDistributionConfiguration",
          "Resource": "arn:${data.aws_partition.current.partition}:imagebuilder:${var.region}:${data.aws_caller_identity.current.account_id}:distribution-configuration/parallelclusterimage-*",
          "Effect": "Allow"
        },
        {
          "Action": [
            "imagebuilder:DeleteImage",
            "imagebuilder:GetImage",
            "imagebuilder:CancelImageCreation"
          ],
          "Resource": "arn:${data.aws_partition.current.partition}:imagebuilder:${var.region}:${data.aws_caller_identity.current.account_id}:image/parallelclusterimage-*/*",
          "Effect": "Allow"
        },
        {
          "Action": "cloudformation:DeleteStack",
          "Resource": "arn:${data.aws_partition.current.partition}:cloudformation:${var.region}:${data.aws_caller_identity.current.account_id}:stack/*/*",
          "Effect": "Allow"
        },
        {
          "Action": "ec2:CreateTags",
          "Resource": "arn:${data.aws_partition.current.partition}:ec2:${var.region}::image/*",
          "Effect": "Allow"
        },
        {
          "Action": "tag:TagResources",
          "Resource": "*",
          "Effect": "Allow"
        },
        {
          "Action": [
            "lambda:DeleteFunction",
            "lambda:RemovePermission"
          ],
          "Resource": "arn:${data.aws_partition.current.partition}:lambda:${var.region}:${data.aws_caller_identity.current.account_id}:function:ParallelClusterImage-*",
          "Effect": "Allow"
        },
        {
          "Action": "logs:DeleteLogGroup",
          "Resource": "arn:${data.aws_partition.current.partition}:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/ParallelClusterImage-*:*",
          "Effect": "Allow"
        },
        {
          "Action": [
            "SNS:GetTopicAttributes",
            "SNS:DeleteTopic",
            "SNS:GetSubscriptionAttributes",
            "SNS:Unsubscribe"
          ],
          "Resource": "arn:${data.aws_partition.current.partition}:sns:${var.region}:${data.aws_caller_identity.current.account_id}:ParallelClusterImage-*",
          "Effect": "Allow"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "admin_role_for_lambda_policy_attachment" {
  role       = aws_iam_role.cleanup_lambda_role.name
  policy_arn = aws_iam_policy.cleanup_lambda_policy.arn
}