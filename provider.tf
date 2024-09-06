terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 1.7"
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = var.tags
  }
}