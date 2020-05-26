data "aws_region" "current" {}

data "aws_eks_cluster" "main" {
  name = var.cluster_id
}

data "aws_eks_cluster_auth" "main" {
  name = var.cluster_id
}

provider "kubernetes" {
  alias                  = "eks"
  host                   = data.aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.main.token
  load_config_file       = false
  version                = ">= 1.11.0"
}

module "iplabs-alb-ingress-controller" {
  source  = "iplabs/alb-ingress-controller/kubernetes"
  version = "3.2.0"

  providers = {
    kubernetes = kubernetes.eks
  }

  k8s_cluster_type = "eks"
  k8s_namespace    = "kube-system"

  aws_region_name  = data.aws_region.current.name
  k8s_cluster_name = data.aws_eks_cluster.main.name
}