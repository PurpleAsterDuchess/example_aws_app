resource "aws_cognito_user_pool" "pool" {
  name = var.cognito_user_pool_name

  username_attributes = ["email"]

  schema {
    name = "email"
    attribute_data_type = "String"
    required = true
  }

  tags = local.tags
}
