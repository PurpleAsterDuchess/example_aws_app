resource "aws_apigatewayv2_api" "lambda" {
  name          = "serverless_lambda_gw"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.lambda.id

  name        = "serverless_lambda_stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

# Health check
resource "aws_apigatewayv2_integration" "health_check" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = aws_lambda_function.health_check.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "health_check" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "GET /health"
  target    = "integrations/${aws_apigatewayv2_integration.health_check.id}"
}

# Post endpoint
resource "aws_apigatewayv2_integration" "post_function" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = aws_lambda_function.post_function.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "post_function" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "POST /post"
  target    = "integrations/${aws_apigatewayv2_integration.post_function.id}"
}

# Get endpoint
resource "aws_apigatewayv2_integration" "get_function" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = aws_lambda_function.get_function.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "get_function" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "GET /get"
  target    = "integrations/${aws_apigatewayv2_integration.get_function.id}"
}

# Cloudwatch
resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.lambda.name}"

  retention_in_days = 30
}

resource "aws_lambda_permission" "api_gw_health_check" {
  statement_id  = "AllowExecutionFromAPIGatewayHealthCheck"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.health_check.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

resource "aws_lambda_permission" "api_gw_post_function" {
  statement_id  = "AllowExecutionFromAPIGatewayPostFunction"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.post_function.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

resource "aws_lambda_permission" "api_gw_get_function" {
  statement_id  = "AllowExecutionFromAPIGatewayGetFunction"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_function.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}
