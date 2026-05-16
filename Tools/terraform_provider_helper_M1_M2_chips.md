## Unable to install Terraform Template v2.2.0 on M1/M2 chipsets

- You will most likely end up with an error like this

Error: Incompatible provider version
│ 
│ Provider registry.terraform.io/hashicorp/template v2.2.0 does not have a package available for your current platform,
│ darwin_arm64.
│ 
│ Provider releases are separate from Terraform CLI releases, so not all providers are available for all platforms. Other versions
│ of this provider may have different platforms supported.
╵
**Resolution**

- `m1-terraform-provider-helper` is A CLI tool to manage the installation of terraform providers for the Mac M1 chip

`
#brew install kreuzwerker/taps/m1-terraform-provider-helper

#m1-terraform-provider-helper activate # (In case you have not activated the helper)

#m1-terraform-provider-helper install hashicorp/template -v 2.10.0 # Install and compile
`

- Once installed run `terraform int` again