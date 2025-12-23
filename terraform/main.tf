terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "6.23.0"
        }
    }

    # backend "s3" {
    # }
}

provider "aws" {
    region = var.aws_region
    profile = var.profile
}

locals {
    tags = {
        project = var.project
        environment = var.environment
        deployment = "terraform"
    }
}