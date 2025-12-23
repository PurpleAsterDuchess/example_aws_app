#!/bin/bash
rm -rf .terraform/
terraform init -backend-config="config.tfvars"