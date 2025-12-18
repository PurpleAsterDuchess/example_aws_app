resource "aws_cognito_user_pool" "pool" {
  name = "demo-user-pool"

  username_attributes = ["email"]

  schema {
    name = "email"
    attribute_data_type = "String"
    required = true
  }

  schema {
    name = "forename"
    attribute_data_type = "String"
  }

  schema {
    name = "surname"
    attribute_data_type = "String"
  }

  password_policy {

  }

  tags = local.tags
}
