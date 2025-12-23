terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "6.23.0"
        }
    }
}

provider "aws" {
    region = var.aws_region
    profile = var.profile
}

resource "aws_s3_bucket" "state_bucket" {
    bucket = var.state_bucket_name

    tags = {
        Name = "Terraform state bucket"
    }

    lifecycle {
      prevent_destroy = true
    }
}
