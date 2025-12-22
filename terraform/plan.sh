#!/bin/bash
terraform plan -var-file="$(dirname $0)/dev.tfvars" -out "$(dirname $0)/terraformPlan"