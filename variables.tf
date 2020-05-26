variable "cluster-name" {
  default = "penroz"
  description = "Name of the cluster"
  type = string
}

variable "aws_region" {
  default = "us-east-1"
  description = "Used AWS Region."
  type = string
}

variable "hosted_zone_url" {
  default = "eks.derinworksllc.com"
  description = "URL of the hosted Zone created in Route53 before Terraform deployment."
  type = string
}