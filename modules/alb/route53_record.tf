resource "aws_route53_record" "main" {
  zone_id = var.hosted_zone_id
  name    = "*.api.${var.hosted_zone_url}"
  type    = "A"
  alias {
    name                   = module.aws-alb.this_lb_dns_name
    zone_id                = module.aws-alb.this_lb_zone_id
    evaluate_target_health = false
  }
}