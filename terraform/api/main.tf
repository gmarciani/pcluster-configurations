module "pcluster_api" {
#  source = "/Users/mgiacomo/workplace/aws-parallelcluster-terraform/terraform-aws-parallelcluster/modules/pcluster_api"
  source  = "aws-tf/parallelcluster/aws//modules/pcluster_api"
  version = "1.0.0"

  region                = var.region
  api_stack_name        = var.api_stack_name
  api_version           = var.api_version

  parameters = {
    EnableIamAdminAccess = "true"
  }
}
