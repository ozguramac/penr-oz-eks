resource "aws_eks_cluster" "main" {
  name            = var.cluster-name
  role_arn        = aws_iam_role.main.arn

  vpc_config {
    security_group_ids = [aws_security_group.main.id]
    subnet_ids         = var.app_subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.main-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.main-AmazonEKSServicePolicy,
  ]
}