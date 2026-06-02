# Azure Utilities (Terraform)

Reusable Terraform modules for deploying connectivity utilities and Ubuntu hosts.

## Contents
- `Azure-Bastion-Host/`: Stand-alone module that provisions Azure Bastion plus the required networking.
- `Azure-VM(Ubuntu)-22.04/` and `Azure-VM(Ubuntu)-24.04/`: Minimal compute modules targeting specific Ubuntu releases.

## Usage
Enter any module directory, run `terraform init`, adjust the variables (see `variables.tf` when provided), then `terraform plan` and `terraform apply`.
