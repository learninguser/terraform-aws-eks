terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.38" # AWS provider version, not terraform version
    }
  }

  backend "s3" {
    bucket = "learninguser"
    key    = "vpc"
    region = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}

provider "aws" {
  region = "us-east-1"
}