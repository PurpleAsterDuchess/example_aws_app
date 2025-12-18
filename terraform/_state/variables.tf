variable "profile" {
    description = "AWS Profile"
    type = string
}

variable "state_bucket_name" {
    description = "Name of the S3 bucket to store Terraform state"
    type = string
    default = "pp-demo-terraform-state-bucket"
}