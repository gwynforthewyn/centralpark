terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.2"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}