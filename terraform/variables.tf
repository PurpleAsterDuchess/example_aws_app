variable "project" {
    description = "Name of project"
    type = string
    default = "demo"
}

variable "profile" {
    description = "AWS Profile"
    type = string
}

variable "environment" {
    description = "Development environment"
    type = string
    default = "dev"
}

variable "aws_region" {
    description = "AWS Region"
    type = string
}

variable "cognito_user_pool_name" {
    description = "Name of user pool in cognito"
    type = string
}