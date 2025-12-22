#!/bin/bash
rm -rf .terraform/
terraform init -backend-config="$(dirname $0)/config.tfvars"