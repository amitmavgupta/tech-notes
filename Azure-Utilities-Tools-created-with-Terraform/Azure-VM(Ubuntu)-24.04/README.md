# Azure Ubuntu 24.04 VM Module

Terraform template tailored for Ubuntu 24.04 virtual machines.

## Files
- `main.tf`: Full VM plus networking definition targeting the 24.04 image.
- `terraform.tf`: Provider definition and backend hints.

## Usage
Update the locals/variables for your subscription, run `terraform init`, and apply the plan to provision the VM.
