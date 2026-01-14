#!/bin/bash

API_URL=$(terraform output -raw base_url)
echo "NEXT_PUBLIC_API_BASE_URL=$API_URL" > ../frontend/.env.local