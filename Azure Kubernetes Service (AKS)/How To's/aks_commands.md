# Azure Kubernetes Service (AKS) Commands

## List AKS Clusters

```bash
az aks list -g prvaksvnet
```

## Create AKS Cluster with Multiple Availability Zones

```bash
az aks create \
    --resource-group myResourceGroup \
    --name myAKSCluster \
    --generate-ssh-keys \
    --vm-set-type VirtualMachineScaleSets \
    --load-balancer-sku standard \
    --node-count 3 \
    --zones 1 2 3
```

## Create AKS Cluster with Custom Network Plugin and VM Size

```bash
az aks create -l eastus -g byocni -n byocni --network-plugin none --kubernetes-version 1.35 --node-vm-size standard_b4ms
```

## Delete AKS Cluster Completely

```bash
az aks delete --resource-group azurecni --name azurecni
az group delete --name azurecni
```

## Update AKS Cluster Tier

```bash
az aks update --resource-group aksdemo --name aksdemo --tier standard
```

## List AKS Versions in a Region

```bash
az aks get-versions --location canada-central --output table
```

## Get Azure Subnet ID

```bash
az network vnet subnet show --resource-group ciliumossazmktplace --name nodesubnet --vnet-name ciliumossazmktplace
```

```bash
az network vnet subnet list --resource-group $resourceGroup --vnet-name $vnet -o json | jq '.[0].id'
```

## Check Nodes Across Regions

```bash
kubectl get nodes -o custom-columns=NAME:'{.metadata.name}',REGION:'{.metadata.labels.topology\.kubernetes\.io/region}',ZONE:'{metadata.labels.topology\.kubernetes\.io/zone}'
```

## Uncordon Nodes in Scheduling Disabled State

```bash
kubectl describe node <node-name>
kubectl uncordon <node-name>
```

## Run Verbose Mode with Azure CLI

```bash
az aro delete -y \
  --resource-group openshift \
  --name cluster --verbose
```
