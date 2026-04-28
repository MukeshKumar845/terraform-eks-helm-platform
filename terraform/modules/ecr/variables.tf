# ECR module input variables
variable "project_name" {
  description = "Project name"
  type        = string
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}