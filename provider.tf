provider "aws" {
  region  = var.aws_region
  profile = "default"
}

terraform {
  required_providers {
    aws = {
      version = "~> 4.20.1"
    }
  }
}
