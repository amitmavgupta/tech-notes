# AKS Operations and Commands Guide

Essential Azure CLI and Kubernetes commands for managing, monitoring, and troubleshooting AKS clusters.

---

## AKS Cluster Commands

### List AKS Clusters

View all AKS clusters in a resource group:

```bash
az aks list -g prvaksvnet
```

### Get Cluster Credentials

Configure kubectl to access your AKS cluster:

```bash
az aks get-credentials --resource-group <resource-group> --name <cluster-name>
```

### Create Cluster with Custom Network Plugin

Create AKS cluster with custom network plugin and VM size:

```bash
az aks create -l eastus -g byocni -n byocni \
  --network-plugin none \
  --kubernetes-version 1.35 \
  --node-vm-size standard_b4ms
```

### Delete AKS Cluster Completely

Remove cluster and associated resource group:

```bash
az aks delete --resource-group azurecni --name azurecni
az group delete --name azurecni
```

### Update Cluster Tier

Modify service tier (free, standard):

```bash
az aks update --resource-group aksdemo --name aksdemo --tier standard
```

### List Available Kubernetes Versions

Check supported Kubernetes versions in a region:

```bash
az aks get-versions --location canada-central --output table
```

### Run Verbose Mode

Enable verbose logging for troubleshooting:

```bash
az aro delete -y \
  --resource-group openshift \
  --name cluster --verbose
```

---

## Network Information

### Get Service CIDR

Query the service CIDR used by the cluster:

```bash
az aks show -n tmetest -g tmetest --subscription XXXXXXXXXXXX | grep serviceCidr
```

**Output:**
```
"serviceCidr": "10.0.0.0/16",
"serviceCidrs": [
```

### Get Pod CIDR

Query the pod CIDR used by the cluster:

```bash
az aks show -n tmetest -g tmetest --subscription XXXXXXXXXXXX | grep podCidr
```

**Output:**
```
"podCidr": "10.244.0.0/16",
"podCidrs": [
```

### Get Azure Subnet ID

Retrieve specific subnet details:

```bash
az network vnet subnet show \
  --resource-group ciliumossazmktplace \
  --vnet-name ciliumossazmktplace \
  --name nodesubnet
```

### List Subnet IDs

Get subnet IDs in JSON format for scripting:

```bash
az network vnet subnet list \
  --resource-group $resourceGroup \
  --vnet-name $vnet -o json | jq '.[0].id'
```

---

## Kubernetes Node Operations

### Check Nodes Across Regions

Display nodes with region and zone information:

```bash
kubectl get nodes -o custom-columns=NAME:'{.metadata.name}',REGION:'{.metadata.labels.topology\.kubernetes\.io/region}',ZONE:'{metadata.labels.topology\.kubernetes\.io/zone}'
```

### Uncordon Nodes in Disabled State

Re-enable scheduling on cordoned nodes:

```bash
kubectl describe node <node-name>
kubectl uncordon <node-name>
```

### Update kubeconfig

Configure kubectl for EKS cluster (cross-cloud reference):

```bash
aws eks update-kubeconfig --region region-code --name my-cluster
```

---

## Identity and Access Management

### Create Azure Managed Identity

Create a managed identity for AKS workload authentication:

```bash
az identity create --name $IDENTITY --resource-group $RESOURCE_GROUP_NAME
```

### Get Identity Principal ID

Extract the principal ID for RBAC role assignment:

```bash
PRINCIPAL_ID=$(az identity show --name $IDENTITY --resource-group $RESOURCE_GROUP_NAME --query principalId -o tsv)
```

### Usage Example

Assign role to managed identity:

```bash
az role assignment create \
  --role "Contributor" \
  --assignee $PRINCIPAL_ID \
  --scope /subscriptions/$SUBSCRIPTION_ID
```

---

## Private Cluster Access - AKS Invoke

### Overview

Access private AKS clusters without VPN, Express Route, or jump boxes using Azure CLI's command invoke feature. Allows remote execution of kubectl and helm commands through the Azure API.

### Prerequisites for Private Clusters

Standard private cluster access requires:
- VPN or Express Route connection
- Jumpbox within cluster VNet
- Private endpoint in another VNet

With **AKS Invoke**, you can bypass these requirements.

### Basic AKS Invoke Command

Execute kubectl commands on private cluster:

```bash
az aks command invoke \
  --resource-group prvaksvnet \
  --name prvaks \
  --command "kubectl get pods -n kube-system"
```

**Output:**
```
command started at 2024-02-19 06:26:24+00:00, finished at 2024-02-19 06:26:24+00:00 with exitcode=0
NAME                                  READY   STATUS    RESTARTS       AGE
azure-cns-5w2zk                       1/1     Running   0              8d
azure-cns-82bgw                       1/1     Running   0              8d
azure-cns-vlc9g                       1/1     Running   0              8d
azure-ip-masq-agent-bmwzb             1/1     Running   0              8d
azure-ip-masq-agent-sr4hk             1/1     Running   0              8d
azure-ip-masq-agent-x89f6             1/1     Running   0              8d
cilium-kd5tj                          1/1     Running   0              3d23h
cilium-mjjbk                          1/1     Running   0              3d23h
cilium-operator-d78f778f7-7zvs9       1/1     Running   0              3d23h
cilium-operator-d78f778f7-ghm5g       1/1     Running   1 (3d9h ago)   3d23h
cilium-vftrz                          1/1     Running   0              3d23h
cloud-node-manager-8b74n              1/1     Running   0              8d
cloud-node-manager-d55lx              1/1     Running   0              8d
cloud-node-manager-ngmf4              1/1     Running   0              8d
coredns-789789675-qc9kn               1/1     Running   0              8d
coredns-789789675-w4v84               1/1     Running   0              8d
coredns-autoscaler-649b947bbd-hxqwr   1/1     Running   0              8d
csi-azuredisk-node-j4jkg              3/3     Running   0              8d
csi-azuredisk-node-l42qt              3/3     Running   0              8d
csi-azuredisk-node-vjp2q              3/3     Running   0              8d
csi-azurefile-node-m565p              3/3     Running   0              8d
csi-azurefile-node-xr75n              3/3     Running   0              8d
csi-azurefile-node-xzwhs              3/3     Running   0              8d
extension-agent-55d4f4795f-pktc6      2/2     Running   0              3d23h
extension-operator-56c8d5f96c-9sgqx   2/2     Running   0              3d23h
hubble-relay-76ff659b59-vkrsf         1/1     Running   0              3d23h
konnectivity-agent-54c85967cb-7tbxr   1/1     Running   0              8d
konnectivity-agent-54c85967cb-mgfdg   1/1     Running   0              8d
metrics-server-5467676b76-7xmh8       2/2     Running   0              8d
metrics-server-5467676b76-kg9l6       2/2     Running   0              8d
```

### Run Multiple Commands

Execute multiple kubectl operations:

```bash
az aks command invoke \
  --resource-group prvaksvnet \
  --name prvaks \
  --command "kubectl get namespaces && kubectl get nodes"
```

### Run Helm Commands

Deploy or manage helm charts on private cluster:

```bash
az aks command invoke \
  --resource-group prvaksvnet \
  --name prvaks \
  --command "helm list -A"
```

---

## Konnectivity Agents

### Overview

Konnectivity agents enable secure communication to private AKS clusters through Azure service tunnels. They provide an alternative to traditional networking solutions.

### Deploy Konnectivity Agents

Konnectivity agents are typically deployed automatically with AKS, but verify deployment:

```bash
kubectl get pods -n kube-system | grep konnectivity
```

**Expected output:**
```
konnectivity-agent-54c85967cb-7tbxr       1/1     Running   0          8d
konnectivity-agent-54c85967cb-mgfdg       1/1     Running   0          8d
```

---

## Notes

- All commands use Azure CLI v2.40+
- Konnectivity is built-in to AKS and doesn't require separate installation
- AKS Invoke is ideal for zero-trust network architectures
- Pod and service CIDRs should be planned before cluster creation
- Use managed identity for workload authentication instead of service principals
