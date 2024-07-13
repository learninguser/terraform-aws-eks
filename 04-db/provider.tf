terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0" # eks module requires more than 5.38
    }
  }
  backend "s3" {
    bucket         = "learninguser"
    key            = "rds"
    region         = "us-east-1"
    dynamodb_table = "terraform_lock"
  }
}

#provide authentication here
provider "aws" {
  region = "us-east-1"
}