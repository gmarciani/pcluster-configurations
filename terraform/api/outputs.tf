output "pcluster_api_invoke_url" {
  value = module.parallelcluster_pcluster_api.parallelcluster["ParallelClusterApiInvokeUrl"]
}

output "pcluster_api_stack_outputs" {
  value = module.parallelcluster_pcluster_api.parallelcluster
}
