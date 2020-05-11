output "vpc_id" {
  value = module.aws-vpc.vpc_id
}

output "private_subnet_ids" {
  value = module.aws-vpc.private_subnets
}

output "public_subnet_ids" {
  value = module.aws-vpc.public_subnets
}