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

variable "subnet_ids" {
  description = "List containing the IDs of all created public subnets."
  type = list(string)
}

variable "vpc_id" {
  description = "VPC id"
  type = string
}

variable "worker_sg_id" {
  description = "ID of the Security Group used by the Kubernetes worker nodes."
  type = string
}