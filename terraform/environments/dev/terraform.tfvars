project_name = "terraform-eks-helm-dev"
aws_region   = "ap-south-1"

vpc_cidr = "10.0.0.0/16"

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnet_cidrs = [
  "10.0.11.0/24",
  "10.0.12.0/24"
]

availability_zones = [
  "ap-south-1a",
  "ap-south-1b"
]

cluster_version  = "1.29"
desired_capacity = 2
min_capacity     = 1
max_capacity     = 3

instance_types = ["t3.medium"]

alert_email = "your-email@example.com"

tags = {
  Environment = "dev"
  Project     = "terraform-eks-helm"
}# Dev environment values
