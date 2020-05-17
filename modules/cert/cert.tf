module "aws-acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "v2.5.0"

  domain_name  = var.domain_name
  zone_id      = var.zone_id

  subject_alternative_names = var.subject_alternative_names

  tags = {
    Name = var.domain_name
  }
}