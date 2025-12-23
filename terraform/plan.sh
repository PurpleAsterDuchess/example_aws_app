#!/bin/bash
terraform plan -var-file="dev.tfvars" -out "terraformPlan"