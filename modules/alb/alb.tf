module "aws-alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "5.0.0"

  name = "${var.cluster-name}-alb"

  load_balancer_type = "application"

  vpc_id             = var.vpc_id
  subnets            = var.subnet_ids
  security_groups    = [
    module.aws-sg-http.this_security_group_id
  ]

  target_groups = [
    {
      name_prefix      = var.cluster-name
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = "main",
    Project = var.cluster-name
  }
}