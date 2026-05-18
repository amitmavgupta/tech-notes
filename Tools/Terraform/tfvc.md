# Terraform version check (tfvc) 

- It is a reporting tool to identify available updates for providers and modules referenced in your Terraform code. It provides clear warning/failure output and resolution guidance for any issues it detects.

```
tfvc .

provider 'hashicorp/random' WARNING Latest match newer than .terraform.lock.hcl config
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

  Resolution
  ───────────────────────────────────────────────────────────────────────────────────────────────────────────
  Consider running 'terraform init -upgrade' to upgrade providers and modules to the latest matching versions

  Details
  ───────────────────────────────────────────────────────────
  Type:                provider
  Path:                .
  Name:                hashicorp/random
  Source:              registry.terraform.io/hashicorp/random
  Version Constraints: ~>3.0
  Version:             3.6.2
  Latest Match:        3.7.1
  Latest Overall:      3.7.1

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


provider 'hashicorp/tls' WARNING Latest match newer than .terraform.lock.hcl config
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

  Resolution
  ───────────────────────────────────────────────────────────────────────────────────────────────────────────
  Consider running 'terraform init -upgrade' to upgrade providers and modules to the latest matching versions

  Details
  ────────────────────────────────────────────────────────
  Type:                provider
  Path:                .
  Name:                hashicorp/tls
  Source:              registry.terraform.io/hashicorp/tls
  Version Constraints: ~>4.0
  Version:             4.0.5
  Latest Match:        4.0.6
  Latest Overall:      4.0.6

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


provider 'hashicorp/time' WARNING Configured version does not match the latest available version
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

  Resolution
  ──────────────────────────────────────────────────────────
  Consider using the latest version of this provider

  Details
  ─────────────────────────────────────────────────────────
  Type:                provider
  Path:                .
  Name:                hashicorp/time
  Source:              registry.terraform.io/hashicorp/time
  Version Constraints: 0.9.1
  Version:             0.9.1
  Latest Match:
  Latest Overall:      0.13.0

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


provider 'hashicorp/azurerm' FAILED .terraform.lock.hcl contains an outdated major version
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

  Resolution
  ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  Ensure that the version constraint for this provider allows the latest overall version and then run 'terraform init -upgrade' to update the .terraform.lock.hcl file

  Details
  ────────────────────────────────────────────────────────────
  Type:                provider
  Path:                .
  Name:                hashicorp/azurerm
  Source:              registry.terraform.io/hashicorp/azurerm
  Version Constraints: ~>3.99.0
  Version:             3.99.0
  Latest Match:
  Latest Overall:      4.26.0

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


provider 'azure/azapi' FAILED .terraform.lock.hcl contains an outdated major version
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

  Resolution
  ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  Ensure that the version constraint for this provider allows the latest overall version and then run 'terraform init -upgrade' to update the .terraform.lock.hcl file

  Details
  ──────────────────────────────────────────────────────
  Type:                provider
  Path:                .
  Name:                azure/azapi
  Source:              registry.terraform.io/azure/azapi
  Version Constraints: ~>1.5
  Version:             1.15.0
  Latest Match:
  Latest Overall:      2.3.0

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
```
