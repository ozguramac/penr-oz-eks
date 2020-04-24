variable "cluster-name" {
  description = "Name of the cluster"
  type = string
}

variable "aws_region" {
  description = "Used AWS Region."
  type = string
}

variable "subnet_count" {
  description = "The number of subnets we want to create per type to ensure high availability."
  type = string
}