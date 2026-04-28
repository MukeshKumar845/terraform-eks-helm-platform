# EKS module input variables
variable "project_name" {
  description = "Project name"
  type        = string
}

variable "cluster_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.29"
}

variable "eks_cluster_role_arn" {
  description = "IAM role ARN for EKS control plane"
  type        = string
}

variable "eks_node_role_arn" {
  description = "IAM role ARN for EKS worker nodes"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  type        = number
}

variable "min_capacity" {
  description = "Minimum worker nodes"
  type        = number
}

variable "max_capacity" {
  description = "Maximum worker nodes"
  type        = number
}

variable "instance_types" {
  description = "EKS node instance types"
  type        = list(string)
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}