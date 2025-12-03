# Azure Bastion Host Module

Terraform configuration for deploying Azure Bastion together with its network dependencies.

## Files
- `main.tf`: Resource definitions for the VNet, subnet, and Bastion host.
- `variables.tf`: Tune address spaces, naming, and SKU values.
- `output.tf`: Connection metadata returned after `terraform apply`.
- `terraform.tf`: Provider/backend settings.

## Usage
Populate a `terraform.tfvars` file (or export variables), then run `terraform init`, `terraform plan`, and `terraform apply` to provision the environment.
