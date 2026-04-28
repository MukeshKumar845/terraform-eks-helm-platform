module "vpc" {
  source = "../../modules/vpc"

  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  tags                 = var.tags
}

module "iam" {
  source = "../../modules/iam"

  project_name = var.project_name
  tags         = var.tags
}

module "eks" {
  source = "../../modules/eks"

  project_name         = var.project_name
  cluster_version      = var.cluster_version
  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  eks_node_role_arn    = module.iam.eks_node_role_arn

  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

  desired_capacity = var.desired_capacity
  min_capacity     = var.min_capacity
  max_capacity     = var.max_capacity

  instance_types = var.instance_types
  tags           = var.tags
}

module "ecr" {
  source = "../../modules/ecr"

  project_name = var.project_name
  tags         = var.tags
}

module "monitoring" {
  source = "../../modules/monitoring"

  project_name = var.project_name
  cluster_name = module.eks.cluster_name
  alert_email  = var.alert_email
  tags         = var.tags
}# Prod environment root module
