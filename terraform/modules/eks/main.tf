# EKS module resources
resource "aws_eks_cluster" "this" {
  name     = "${var.project_name}-eks-cluster"
  role_arn = var.eks_cluster_role_arn

  version = var.cluster_version

  vpc_config {
    subnet_ids = concat(var.public_subnet_ids, var.private_subnet_ids)

    endpoint_private_access = true
    endpoint_public_access  = true
  }

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  tags = merge(var.tags, {
    Name = "${var.project_name}-eks-cluster"
  })
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.project_name}-node-group"
  node_role_arn   = var.eks_node_role_arn

  subnet_ids = var.private_subnet_ids

  scaling_config {
    desired_size = var.desired_capacity
    min_size     = var.min_capacity
    max_size     = var.max_capacity
  }

  instance_types = var.instance_types
  capacity_type  = "ON_DEMAND"

  ami_type = "AL2_x86_64"

  tags = merge(var.tags, {
    Name = "${var.project_name}-node-group"
  })

  depends_on = [aws_eks_cluster.this]
}