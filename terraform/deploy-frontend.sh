#!/bin/bash

# Build and deploy Next.js frontend to S3
cd ../frontend
npm run build

# Deploy to S3
cd ../terraform
BUCKET_NAME=$(terraform output -raw frontend_bucket_name)
FRONTEND_URL=$(terraform output -raw frontend_url)

aws s3 sync ../frontend/out/ s3://$BUCKET_NAME/ --delete

echo "Frontend URL: $FRONTEND_URL"
