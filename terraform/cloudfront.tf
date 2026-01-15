# S3 website endpoint (no CloudFront since permissions are restricted)
output "frontend_url" {
  description = "Frontend S3 website URL"
  value       = "http://${aws_s3_bucket.frontend_bucket.website_endpoint}"
}

