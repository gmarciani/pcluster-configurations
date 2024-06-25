provider "aws" {
  region  = var.region
  profile = var.profile
}

provider "aws-parallelcluster" {
  region         = var.region
  profile        = var.profile
  endpoint = module.parallelcluster.parallelcluster.ParallelClusterApiInvokeUrl
  role_arn = module.parallelcluster.parallelcluster.ParallelClusterApiUserRole
#  api_stack_name = var.api_stack_name
#  use_user_role  = true
}
