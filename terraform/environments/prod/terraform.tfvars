project_name = "terraform-eks-helm-prod"
aws_region   = "ap-south-1"

vpc_cidr = "10.1.0.0/16"

public_subnet_cidrs = [
  "10.1.1.0/24",
  "10.1.2.0/24"
]

private_subnet_cidrs = [
  "10.1.11.0/24",
  "10.1.12.0/24"
]

availability_zones = [
  "ap-south-1a",
  "ap-south-1b"
]

cluster_version  = "1.29"
desired_capacity = 4
min_capacity     = 2
max_capacity     = 6

instance_types = ["m5.large"]

alert_email = "your-email@example.com"

tags = {
  Environment = "prod"
  Project     = "terraform-eks-helm"
}# Prod environment values
