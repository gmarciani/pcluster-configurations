provider "aws" {
  region  = var.region
  profile = var.profile
}

provider "pcluster" {
  region         = var.region
  profile        = var.profile
  api_stack_name = var.api_stack_name
  use_user_role  = true
}
