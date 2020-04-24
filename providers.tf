provider "aws" {
  region  = var.aws_region
  version = "~> 2.58"
}

provider "external" {
  version = "~> 1.2"
}

provider "http" {
  version = "~> 1.2"
}