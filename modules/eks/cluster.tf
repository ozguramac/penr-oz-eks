module "aws-eks" {
  source       = "terraform-aws-modules/eks/aws"
  cluster_name = var.cluster-name
  subnets      = var.subnet_ids

  tags = {
    Environment = "main"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id = var.vpc_id

  worker_groups = [
    {
      name                          = "${var.cluster-name}-worker-group"
      instance_type                 = "t2.small"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 2
      additional_security_group_ids = [aws_security_group.worker.id]
    },
  ]
}

data "aws_eks_cluster" "main" {
  name = module.aws-eks.cluster_id
}

data "aws_eks_cluster_auth" "main" {
  name = module.aws-eks.cluster_id
}