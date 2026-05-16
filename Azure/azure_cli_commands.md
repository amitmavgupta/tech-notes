# Azure CLI Commands

## List VM Sizes

```bash
az vm list-sizes --location "eastus" --output table
```

## List All Providers

```bash
az provider list --output table
```

## Account and Subscription Management

### List All Subscriptions

```bash
az account list --output table
```

### Set Subscription

```bash
az account set --subscription <subscription-id>
```

Example:
```bash
az account set --subscription 8dbd2563-77eb-41a1-917b-5a1344da9767
```

### List Available Locations

```bash
az account list-locations -o table
```

## Azure CLI Extensions

### Add Extension

```bash
az extension add --name aks-preview
```

### Remove Extension

```bash
az extension remove --name aks-preview
```

### List Extensions

```bash
az extension list
```

### Update Extension

```bash
az extension update --name "aks-preview"
az extension update -n aks-preview --allow-preview true
```

## Install Azure CLI on Debian/Ubuntu

```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | bash
```

## Manual Installation Steps

```bash
sudo apt-get update
sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg

sudo mkdir -p /etc/apt/keyrings
curl -sLS https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
sudo chmod go+r /etc/apt/keyrings/microsoft.gpg

AZ_REPO=$(lsb_release -cs)
echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list

sudo apt-get update
sudo apt-get install azure-cli
```

## Troubleshooting

### ResourceGroupNotFound Error

If you encounter a ResourceGroupNotFound error, ensure you have the correct subscription set:

```bash
az account list --output table
az account set --subscription <subscription-id>
```
