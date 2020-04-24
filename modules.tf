module "network" {
  source = "./modules/network"
  aws_region = var.aws_region
  cluster-name = var.cluster-name
  subnet_count = var.subnet_count
}

module "eks" {
  source = "./modules/eks"
  accessing_computer_ip = local.accessing_computer_ip
  app_subnet_ids = module.network.app_subnet_ids
  aws_region = var.aws_region
  cluster-name = var.cluster-name
  keypair-name = var.keypair-name
  vpc_id = module.network.vpc_id
}

module "cert" {
  source = "./modules/cert"
  aws_region = var.aws_region
  domain_name = var.hosted_zone_url
  hosted_zone_id = var.hosted_zone_id
  subject_alternative_names = ["*.${var.hosted_zone_url}"]
}

module "alb" {
  source = "./modules/alb"
  cluster-name = var.cluster-name
  hosted_zone_id = var.hosted_zone_id
  hosted_zone_url = var.hosted_zone_url
  gateway_subnet_ids = module.network.gateway_subnet_ids
  lb_certificate_arn = module.cert.arn
  lb_target_group_arn = module.eks.target_group_arn
  node_sg_id = module.eks.node_sg_id
  vpc_id = module.network.vpc_id
}
