variable "region" {
  description = "The region the ParallelCluster API is deployed in."
  type        = string
  default     = "us-east-1"
}

variable "profile" {
  type        = string
  description = "The AWS profile used to deploy the clusters."
  default     = null
}

variable "api_stack_name" {
  type        = string
  description = "The name of the CloudFormation stack used to deploy the ParallelCluster API."
  default     = "ParallelCluster"
}

variable "api_version" {
  type        = string
  description = "The version of the ParallelCluster API."
}

variable "image_id" {
  type        = string
  description = "The ID that will be given to the custom image."
}

variable "parent_image" {
  type        = string
  description = "The parent image ID."
}

variable "build_instance_type" {
  type        = string
  description = "The instance type to use to build the image."
}