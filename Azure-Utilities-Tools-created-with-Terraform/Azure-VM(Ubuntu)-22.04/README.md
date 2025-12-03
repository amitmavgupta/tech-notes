# Azure Ubuntu 22.04 VM Module

Minimal Terraform template for spinning up an Ubuntu 22.04 virtual machine.

## Files
- `main.tf`: Defines the resource group, networking, and VM configuration.
- `terraform.tf`: Provider definition and required version pins.

## Usage
Edit the variable values near the top of `main.tf` (resource group name, location, VM size), then run `terraform init` followed by `terraform apply`.
