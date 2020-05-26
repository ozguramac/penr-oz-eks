variable "aws_iam_role_for_policy" {
  description = "AWS role name for attaching IAM policy"
  type = string
}

variable "cluster_id" {
  description = "Cluster ID of the existing EKS"
}

variable "hosted_domain" {
  description = "URL of the hosted Zone created in Route53 before Terraform deployment."
  type = string
}