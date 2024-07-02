module "parallelcluster" {
  #  source = "/Users/mgiacomo/workplace/aws-parallelcluster-terraform/terraform-aws-parallelcluster"
  source  = "aws-tf/parallelcluster/aws"
  version = "1.0.0"

  region                = var.region
  api_stack_name        = var.api_stack_name
  api_version           = var.api_version
#  deploy_pcluster_api   = true
  deploy_pcluster_api   = false
  parameters = {
    EnableIamAdminAccess = "true"
  }

  template_vars         = local.config_vars
  cluster_configs       = local.cluster_configs
  config_path           = "config/clusters.yaml"
}
