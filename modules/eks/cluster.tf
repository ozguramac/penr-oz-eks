
data "aws_eks_cluster" "main" {
  name = module.aws-eks.cluster_id
}

data "aws_eks_cluster_auth" "main" {
  name = module.aws-eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.main.token
  load_config_file       = false
  version                = ">= 1.11.1"
}

module "aws-eks" {
  source       = "terraform-aws-modules/eks/aws"
  version      = "11.1.0"

  config_output_path = "~/.kube/config"

  cluster_name = "${var.cluster-name}-eks"
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