data "aws_region" "current" {}

data "aws_eks_cluster" "main" {
  name = module.aws-eks.cluster_id
}

data "aws_eks_cluster_auth" "main" {
  name = module.aws-eks.cluster_id
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