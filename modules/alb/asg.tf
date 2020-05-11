data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["137112412989"] # Amazon

  filter {
    name = "name"

    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "amazon",
    ]
  }
}

module "aws-asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "3.5.0"

  name = "${var.cluster-name}-asg"

  lc_name = "${var.cluster-name}-lc"

  image_id        = data.aws_ami.amazon_linux.id
  instance_type   = "t2.micro"
  security_groups = [
    module.aws-sg-http.this_security_group_id,
    module.aws-sg-https.this_security_group_id
  ]

  ebs_block_device = [
    {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = "50"
      delete_on_termination = true
    },
  ]

  root_block_device = [
    {
      volume_size = "50"
      volume_type = "gp2"
    },
  ]

  # Auto scaling group
  asg_name                  = "${var.cluster-name}-asg"
  vpc_zone_identifier       = var.subnet_ids
  health_check_type         = "EC2"
  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 0
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "Environment"
      value               = "main"
      propagate_at_launch = true
    },
    {
      key                 = "Project"
      value               = var.cluster-name
      propagate_at_launch = true
    },
  ]
}