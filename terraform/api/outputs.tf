output "pcluster_api_stack_name" {
  value = module.pcluster_api.stack_name
}

output "pcluster_api_stack_parameters" {
  value = module.pcluster_api.stack_parameters
}

output "pcluster_api_stack_outputs" {
  value = module.pcluster_api.stack_outputs
}

output "pcluster_api_invoke_url" {
  value = module.pcluster_api.stack_outputs["ParallelClusterApiInvokeUrl"]
}
