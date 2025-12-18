terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "6.23.0"
        }
    }

    backend "s3" {
    bucket         = "demo_bucket"
    key            = "example_aws_app/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    }

    provider "aws" {
        region = var.region
        profile = var.profile
    }

    locals {
        tags = {
            project = var.project
            environment = var.environment
            deployment = "terraform"
        }
    }
}