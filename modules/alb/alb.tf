resource "aws_alb" "main-alb" {
  name            = "${var.cluster-name}-alb"
  subnets         = var.subnet_ids
  security_groups = [var.worker_sg_id, aws_security_group.main-alb.id]
  ip_address_type = "ipv4"

  tags = map(
     "Name", "${var.cluster-name}-alb",
     "kubernetes.io/cluster/${var.cluster-name}", "owned",
    )
}

resource "aws_alb_listener" "main-alb" {
  load_balancer_arn = aws_alb.main-alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type          = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_target_group" "main" {
  name = "${var.cluster-name}-nodes"
  port = 31742
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = "instance"
}

resource "aws_alb_listener" "main-alb-ssl" {
  load_balancer_arn = aws_alb.main-alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = var.lb_certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}