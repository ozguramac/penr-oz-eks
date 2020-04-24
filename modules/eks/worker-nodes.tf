########################################################################################
# Setup AutoScaling Group for worker nodes

# Setup data source to get amazon-provided AMI for EKS nodes
data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}

data "aws_region" "current" {}

# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We utilize a Terraform local here to simplify Base64 encode this
# information and write it into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
locals {
  main-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh \
--apiserver-endpoint '${aws_eks_cluster.main.endpoint}' \
--b64-cluster-ca '${aws_eks_cluster.main.certificate_authority.0.data}' \
'${var.cluster-name}'
USERDATA
}

resource "aws_launch_configuration" "main" {
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.node.name
  image_id                    = data.aws_ami.eks-worker.id
  instance_type               = "m4.large"
  name_prefix                 = var.cluster-name
  security_groups             = [aws_security_group.main-node.id]
  user_data_base64            = base64encode(local.main-node-userdata)
  key_name                    = var.keypair-name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "main" {
  name = "${var.cluster-name}-nodes"
  port = 31742
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = "instance"
}

resource "aws_autoscaling_group" "main" {
  desired_capacity     = "2"
  launch_configuration = aws_launch_configuration.main.id
  max_size             = "3"
  min_size             = 1
  name                 = var.cluster-name
  vpc_zone_identifier  = var.app_subnet_ids
  target_group_arns    = [aws_lb_target_group.main.arn]

  tag {
    key                 = "Name"
    value               = var.cluster-name
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster-name}"
    value               = "owned"
    propagate_at_launch = true
  }
}

########################################################################################
# setup provider for kubernetes

data "external" "aws_iam_authenticator" {
  program = ["sh", "-c", "aws-iam-authenticator token -i main | jq -r -c .status"]
}

provider "kubernetes" {
  host                      = aws_eks_cluster.main.endpoint
  cluster_ca_certificate    = base64decode(aws_eks_cluster.main.certificate_authority.0.data)
  token                     = data.external.aws_iam_authenticator.result.token
  load_config_file          = false
  version = "~> 1.5"
}

# Allow worker nodes to join cluster via config map
resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    mapRoles = <<EOF
- rolearn: ${aws_iam_role.main-node.arn}
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes
EOF
  }
  depends_on = [
    aws_eks_cluster.main,
    aws_autoscaling_group.main
  ]
}