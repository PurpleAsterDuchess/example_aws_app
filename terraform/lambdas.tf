
resource "random_pet" "lambda_bucket_name" {
  prefix = "pp-demo-lambda-bucket"
  length = 4
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id
}

resource "aws_s3_bucket_ownership_controls" "lambda_bucket" {
  bucket = aws_s3_bucket.lambda_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "lambda_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.lambda_bucket]

  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

data "archive_file" "lambda_health_check" {
  type = "zip"

  source_dir  = "../backend"
  output_path = "../backend.zip"
}

resource "aws_s3_object" "lambda_health_check" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "backend.zip"
  source = data.archive_file.lambda_health_check.output_path

  etag = filemd5(data.archive_file.lambda_health_check.output_path)
}


resource "aws_lambda_function" "health_check" {
  function_name = "HealthCheck"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_health_check.key

  runtime = "nodejs20.x"
  handler = "health-check.handler"

  source_code_hash = data.archive_file.lambda_health_check.output_base64sha256

  role = "arn:aws:iam::572974615746:role/LabRole"
}

resource "aws_cloudwatch_log_group" "health_check" {
  name = "/aws/lambda/${aws_lambda_function.health_check.function_name}"

  retention_in_days = 30
}

