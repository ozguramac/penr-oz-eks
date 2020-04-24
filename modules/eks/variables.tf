variable "accessing_computer_ip" {
  description = "Public IP of the computer accessing the cluster via kubectl or browser."
  type = string
}

variable "app_subnet_ids" {
  description = "Subnet ids"
  type = list(string)
}

variable "aws_region" {
  description = "Used AWS region"
  type = string
}

variable "cluster-name" {
  description = "Name of the cluster"
  type = string
}

variable "keypair-name" {
  description = "Name of the keypair declared in AWS IAM, used to connect into your instances via SSH."
  type = string
}

variable "vpc_id" {
  description = "VPC id"
  type = string
}