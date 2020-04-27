variable "cluster-name" {
  description = "Name of the cluster"
  type = string
}

variable "subnet_ids" {
  description = "List containing the IDs of all created private subnets."
  type = list(string)
}

variable "vpc_id" {
  description = "VPC id"
  type = string
}