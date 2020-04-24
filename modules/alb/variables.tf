variable "lb_certificate_arn" {
  description = "Arn of the issued ACM certificate"
  type = string
}

variable "cluster-name" {
  description = "Name of the cluster"
  type = string
}

variable "hosted_zone_id" {
  description = "ID of the hosted Zone created in Route53 before Terraform deployment."
  type = string
}

variable "hosted_zone_url" {
  description = "URL of the hosted Zone created in Route53 before Terraform deployment."
  type = string
}

variable "gateway_subnet_ids" {
  description = "List containing the IDs of all created gateway subnets."
  type = list(string)
}

variable "lb_target_group_arn" {
  description = "ARN of the Target Group pointing at the Kubernetes nodes."
  type = string
}

variable "node_sg_id" {
  description = "ID of the Security Group used by the Kubernetes worker nodes."
  type = string
}

variable "vpc_id" {
  description = "VPC id"
  type = string
}
