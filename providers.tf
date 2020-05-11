provider "aws" {
  region  = var.aws_region
  version = ">= 2.52.0"
}

provider "external" {
  version = "~> 1.2"
}

provider "http" {
  version = "~> 1.2"
}

provider "local" {
  version = ">= 1.2"
}

provider "null" {
  version = ">= 2.1"
}

provider "random" {
  version = ">= 2.1"
}

provider "template" {
  version = ">= 2.1"
}

terraform {
  required_version = ">= 0.12.9"
}
