resource "aws_cognito_user_pool" "pool" {
  name = "demo-user-pool"

  username_attributes = ["email"]

  schema {
    name = "email"
    attribute_data_type = "String"
    required = true
  }

  tags = local.tags
}
