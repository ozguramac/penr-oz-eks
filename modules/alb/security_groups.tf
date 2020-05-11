module "aws-sg-https" {
  source = "terraform-aws-modules/security-group/aws//modules/https-443"
  version = "3.8.0"

  name        = "${var.cluster-name}-sg-https"
  description = "Security group with HTTPS ports open within VPC"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = ["10.10.0.0/16"]
}

module "aws-sg-http" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"
  version = "3.8.0"

  name        = "${var.cluster-name}-sg-http"
  description = "Security group with HTTP ports open within VPC"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = ["10.10.0.0/16"]
}
