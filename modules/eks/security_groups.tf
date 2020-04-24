resource "aws_security_group" "main" {
  name        = var.cluster-name
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.cluster-name
  }
}

resource "aws_security_group" "main-node" {
  name        = "${var.cluster-name}-node"
  description = "Security group for all nodes in the cluster"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.cluster-name
  }
}

# Allow inbound traffic from your local workstation external IP to the Kubernetes
resource "aws_security_group_rule" "main-ingress-workstation-https" {
  cidr_blocks       = ["${var.accessing_computer_ip}/32"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.main.id
  to_port           = 443
  type              = "ingress"
}

########################################################################################
# Setup worker node security group

resource "aws_security_group_rule" "main-node-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.main-node.id
  source_security_group_id = aws_security_group.main-node.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "main-node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.main-node.id
  source_security_group_id = aws_security_group.main.id
  to_port                  = 65535
  type                     = "ingress"
}

# allow worker nodes to access EKS master
resource "aws_security_group_rule" "main-ingress-main-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.main-node.id
  source_security_group_id = aws_security_group.main.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "main-node-ingress-main-https" {
  description              = "Allow cluster control to receive communication from the worker Kubelets"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.main.id
  source_security_group_id = aws_security_group.main-node.id
  to_port                  = 443
  type                     = "ingress"
}
