#!bin/bash
terraform plan -destroy -var-file="dev.tfvars" -out="destroy.plan"
terraform show -no-color "destroy.plan"