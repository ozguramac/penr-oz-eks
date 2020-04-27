variable "cluster-name" {
  default = "penr-oz-eks"
  description = "Name of the cluster"
  type = string
}

variable "aws_region" {
  default = "us-east-1"
  description = "Used AWS Region."
  type = string
}

variable "hosted_zone_id" {
  default = "Z04861733S7P0YUZM4061"
  description = "ID of the hosted Zone created in Route53 before Terraform deployment."
  type = string
}

variable "hosted_zone_url" {
  default = "eks.derinworksllc.com"
  description = "URL of the hosted Zone created in Route53 before Terraform deployment."
  type = string
}