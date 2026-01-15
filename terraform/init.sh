#!/bin/bash
rm -rf .terraform/
terraform init -backend-config="config.tfvars"

API_URL=$(terraform output -raw base_url)
echo "NEXT_PUBLIC_API_BASE_URL=$API_URL" > ../frontend/.env.local