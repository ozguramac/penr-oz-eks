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
  zone_id = var.hosted_zone_id
  subject_alternative_names = ["*.${var.hosted_zone_url}"]
}

module "alb" {
  source = "./modules/alb"
  cluster-name = var.cluster-name
  hosted_zone_id = var.hosted_zone_id
  hosted_zone_url = var.hosted_zone_url
  lb_certificate_arn = module.cert.arn
  subnet_ids = module.network.public_subnet_ids
  vpc_id = module.network.vpc_id
  worker_sg_id = module.eks.worker_sg_id
}