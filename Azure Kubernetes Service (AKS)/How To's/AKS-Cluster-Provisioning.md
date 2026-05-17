# AKS Cluster Provisioning Guide

Comprehensive guide for provisioning Azure Kubernetes Service (AKS) clusters with various networking configurations and optimizations.

---

## Prerequisites

- Azure CLI installed and configured
- Appropriate Azure subscription access
- Resource groups created as needed
- VNet and subnet planning completed

---

## Azure CNI (Container Networking Interface)

### Basic Azure CNI Cluster

Create a basic AKS cluster with Azure CNI networking:

```bash
clusterName="azurecnitocilium"
resourceGroup="azurecnitocilium"
vnet="azurecnitocilium"
location="canadacentral"

# Create resource group
az group create --name $resourceGroup --location $location

# Create virtual network with subnets
az network vnet create -g $resourceGroup --location $location --name $clusterName --address-prefixes 10.0.0.0/8 -o none

az network vnet subnet create -g $resourceGroup --vnet-name $vnet --name $clusterName --address-prefixes 10.240.0.0/16 -o none 

# Get subnet ID
subnetid=$(az network vnet subnet show --resource-group $resourceGroup --vnet-name $vnet --name $clusterName --query id -o tsv)

# Create AKS cluster with Azure CNI
az aks create -n $clusterName -g $resourceGroup -l $location --network-plugin azure --vnet-subnet-id $subnetid
```

### Multiple Availability Zones

Create an AKS cluster spread across multiple availability zones for high availability:

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

---

## Azure CNI Powered by Cilium

### Overview

Azure CNI Powered by Cilium combines Azure CNI's control plane with Cilium's data plane for high-performance networking and security. It supports two IPAM modes:
- **VNet mode**: Assign IP addresses from virtual network (Dynamic Pod IP Assignment)
- **Overlay mode**: Assign IP addresses from overlay network (limited IP space scenarios)

**Limitations:**
- Linux only (no Windows support)
- Cilium L7 policy enforcement disabled
- Hubble disabled
- `internalTrafficPolicy=Local` not supported
- Multiple services can't share the same host port with different protocols

### VNet Mode (Dynamic IP)

Deploy Azure CNI Powered by Cilium using VNet IP assignment:

```bash
az group create --name cluster1 --location canadacentral

az network vnet create -g cluster1 --location canadacentral --name cluster1 --address-prefixes 192.168.16.0/22 -o none

az network vnet subnet create -g cluster1 --vnet-name cluster1 --name nodesubnet --address-prefixes 192.168.16.0/24 -o none

az network vnet subnet create -g cluster1 --vnet-name cluster1 --name podsubnet --address-prefixes 192.168.17.0/24 -o none

az aks create -n cluster1 -g cluster1 -l canadacentral \
  --max-pods 250 \
  --network-plugin azure \
  --vnet-subnet-id /subscriptions/<subscription>/resourceGroups/cluster1/providers/Microsoft.Network/virtualNetworks/cluster1/subnets/nodesubnet \
  --pod-subnet-id /subscriptions/<subscription>/resourceGroups/cluster1/providers/Microsoft.Network/virtualNetworks/cluster1/subnets/podsubnet \
  --network-dataplane cilium

az aks get-credentials --resource-group cluster1 --name cluster1
```

### Overlay Mode

Deploy Azure CNI Powered by Cilium with overlay networking for large pod scaling:

```bash
az group create --name azpcoverlay --location francecentral

az aks create -n azpcoverlay -g azpcoverlay -l francecentral \
  --network-plugin azure \
  --network-plugin-mode overlay \
  --pod-cidr 192.168.0.0/16 \
  --network-dataplane cilium

# Or with specific Kubernetes version
az aks create -n azpcoverlay -g azpcoverlay -l francecentral \
  --network-plugin azure \
  --network-plugin-mode overlay \
  --pod-cidr 192.168.0.0/16 \
  --kubernetes-version 1.29 \
  --network-dataplane cilium
```

### Node Subnet Mode

Deploy using only node subnet (pods also use node subnet):

```bash
az aks create -n nodesubnet-cluster -g nodesubnet-rg -l westus \
  --network-plugin azure \
  --vnet-subnet-id /subscriptions/<subscription>/resourceGroups/nodesubnet-rg/providers/Microsoft.Network/virtualNetworks/nodesubnet-vnet/subnets/nodesubnet \
  --network-dataplane cilium
```

---

## Azure CNI with Azure Policy

Deploy Azure CNI cluster with integrated Azure Policy for governance:

```bash
az aks create -n policy-cluster -g policy-rg -l eastus \
  --network-plugin azure \
  --enable-managed-identity \
  --enable-azure-policy
```

---

## Azure CNI Overlay Mode

Deploy Azure CNI with overlay networking (without Cilium):

```bash
az aks create -n overlay-cluster -g overlay-rg -l eastus \
  --network-plugin azure \
  --network-plugin-mode overlay \
  --pod-cidr 10.244.0.0/16
```

---

## BYO CNI (Bring Your Own CNI)

### Basic BYO CNI Cluster

Deploy a cluster without built-in CNI networking for custom CNI installation:

```bash
az aks create -l eastus -g byocni -n byocni \
  --network-plugin none \
  --kubernetes-version 1.35 \
  --node-vm-size standard_b4ms
```

### BYO CNI with Azure Linux

Deploy BYO CNI cluster using Azure Linux OS:

```bash
az aks create -n byocni-linux -g byocni-linux-rg -l eastus \
  --network-plugin none \
  --os-type Linux \
  --os-sku AzureLinux
```

---

## Kubenet with Calico

### Kubenet + Calico Integration

Deploy cluster using Kubenet with Calico network policy enforcement:

```bash
# Create resource group and virtual network
az group create --name kubenet-calico-rg --location eastus

az network vnet create \
  -g kubenet-calico-rg \
  -n kubenet-calico-vnet \
  --address-prefixes 10.0.0.0/8

az network vnet subnet create \
  -g kubenet-calico-rg \
  --vnet-name kubenet-calico-vnet \
  -n kubenetnodes \
  --address-prefixes 10.240.0.0/16

# Create cluster with Kubenet
az aks create \
  -g kubenet-calico-rg \
  -n kubenet-calico \
  --network-plugin kubenet \
  --service-cidr 10.0.0.0/16 \
  --docker-bridge-address 172.17.0.1/16 \
  --vnet-subnet-id /subscriptions/<subscription>/resourceGroups/kubenet-calico-rg/providers/Microsoft.Network/virtualNetworks/kubenet-calico-vnet/subnets/kubenetnodes \
  --network-policy calico
```

---

## Specialized Deployments

### RDMA/Infiniband with Azure CNI Powered by Cilium

Deploy for high-performance computing workloads requiring RDMA capabilities:

```bash
az group create --name rdma-cilium-rg --location eastus

az network vnet create \
  -g rdma-cilium-rg \
  -n rdma-vnet \
  --address-prefixes 10.0.0.0/8

az network vnet subnet create \
  -g rdma-cilium-rg \
  --vnet-name rdma-vnet \
  -n rdmasubnet \
  --address-prefixes 10.0.0.0/16

az aks create \
  -n rdma-cluster \
  -g rdma-cilium-rg \
  -l eastus \
  --network-plugin azure \
  --network-dataplane cilium \
  --node-vm-size Standard_HB120rs_v3
```

### ARM-Based Node Pool Creation

Create ARM-based nodes for cost-effective workloads:

```bash
az aks nodepool add \
  --resource-group <resource-group> \
  --cluster-name <cluster-name> \
  --name armnodepool \
  --node-vm-size Standard_D4ps_v5 \
  --os-type Linux \
  --os-sku Ubuntu
```

---

## Cluster Management

### Delete AKS Cluster Completely

Remove cluster and associated resources:

```bash
az aks delete --resource-group azurecni --name azurecni
az group delete --name azurecni
```

### Update Cluster Tier

Change cluster service tier:

```bash
az aks update --resource-group aksdemo --name aksdemo --tier standard
```

### List AKS Clusters

View all clusters in a resource group:

```bash
az aks list -g prvaksvnet
```

### List Available Kubernetes Versions

Check Kubernetes versions available in a region:

```bash
az aks get-versions --location canada-central --output table
```

### Get Azure Subnet ID

Retrieve subnet information for cluster networking:

```bash
az network vnet subnet show \
  --resource-group ciliumossazmktplace \
  --vnet-name ciliumossazmktplace \
  --name nodesubnet
```

List subnet IDs in JSON format:

```bash
az network vnet subnet list \
  --resource-group $resourceGroup \
  --vnet-name $vnet -o json | jq '.[0].id'
```

---

## Notes

- All commands use Azure CLI v2.40+
- Ensure proper RBAC permissions in your Azure subscription
- Plan IP address spaces carefully, especially for Azure CNI deployments
- Use multiple availability zones for production clusters
- Cilium dataplane is recommended for advanced networking scenarios
- BYO CNI requires manual CNI plugin installation post-cluster creation
