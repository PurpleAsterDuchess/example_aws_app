#!/bin/bash
terraform plan -var-file="state-dev.tfvars" -out="terraformPlan"