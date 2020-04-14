#
# Provider Configuration
#
provider "aws" {
  region = "us-east-1"
  version = ">= 2.38.0"
}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}