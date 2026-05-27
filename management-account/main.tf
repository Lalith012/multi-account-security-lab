# -------------------------------------------------------
# Multi-Account AWS Security Architecture
# Management Account — Main Terraform Configuration
# Account: 986151953551
# Region: ap-south-1 (Mumbai)
# -------------------------------------------------------

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

backend "s3" {
    bucket       = "terraform-state-986151953551"
    key          = "management-account/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
    profile      = "management"
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "management"
}