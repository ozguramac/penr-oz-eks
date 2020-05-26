module "network" {
  source = "./modules/network"
  cluster-name = var.cluster-name
}

module "eks" {
  source = "./modules/eks"
  cluster-name = var.cluster-name
  subnet_ids = module.network.private_subnet_ids
  vpc_id = module.network.vpc_id
}

module "cert" {
  source = "./modules/cert"
  domain_name = var.hosted_zone_url
  subject_alternative_names = ["*.${var.hosted_zone_url}"]
}

module "alb" {
  source = "./modules/alb"
  cluster-name = var.cluster-name
  subnet_ids = module.network.public_subnet_ids
  vpc_id = module.network.vpc_id
}

module "ingress" {
  source = "./modules/ingress"
  cluster_id = module.eks.cluster_id
}

module "dns" {
  source = "./modules/dns"
  aws_iam_role_for_policy = module.eks.worker_iam_role_name
  cluster_id = module.eks.cluster_id
  hosted_domain = var.hosted_zone_url
}