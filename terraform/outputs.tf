# Output value definitions

output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."

  value = aws_s3_bucket.lambda_bucket.id
}

output "function_name" {
  description = "Deployed Lambda function name."

  value = aws_lambda_function.health_check.function_name
}

output "base_url" {
  description = "Base URL for API Gateway stage."

  value = aws_apigatewayv2_stage.lambda.invoke_url
}
