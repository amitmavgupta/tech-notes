# AKS Advanced Networking Guide

Advanced networking configuration for AKS including Cilium integration, load balancer management, ingress setup, and specialized deployments.

---

## Azure CNI with Cilium Integration

### Cilium Ingress Controller Setup

Deploy Cilium as the ingress controller for advanced traffic management:

```bash
# Create cluster with Cilium
az group create --name cilium-ingress-rg --location eastus

az network vnet create \
  -g cilium-ingress-rg \
  -n cilium-vnet \
  --address-prefixes 10.0.0.0/8

az network vnet subnet create \
  -g cilium-ingress-rg \
  --vnet-name cilium-vnet \
  -n cilium-subnet \
  --address-prefixes 10.240.0.0/16

az aks create \
  -n cilium-cluster \
  -g cilium-ingress-rg \
  -l eastus \
  --network-plugin azure \
  --network-dataplane cilium
```

### Install Cilium Ingress

Deploy Cilium ingress configuration:

```bash
helm repo add cilium https://helm.cilium.io
helm install cilium cilium/cilium \
  --namespace cilium \
  --create-namespace \
  --values cilium-values.yaml
```

---

## Azure Load Balancer Configuration

### Internal Load Balancer Annotation

Use Kubernetes service annotations to create internal load balancers:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: internal-service
  annotations:
    service.beta.kubernetes.io/azure-load-balancer-internal: "true"
spec:
  type: LoadBalancer
  selector:
    app: myapp
  ports:
  - port: 80
    targetPort: 8080
```

### Verify Internal Load Balancer Placement (IPv4)

Check if internal load balancer was created in the correct subnet:

```bash
az network vnet subnet show \
  --resource-group MC_byocni_amit_eastus \
  --vnet-name aks-vnet-17718742 \
  --name app-testing
```

**Output:**
```json
{
  "addressPrefix": "10.228.0.0/28",
  "ipConfigurations": [
    {
      "id": "/subscriptions/.../loadBalancers/KUBERNETES-INTERNAL/frontendIPConfigurations/...",
      "resourceGroup": "MC_BYOCNI_AMIT_EASTUS"
    }
  ],
  "name": "app-testing",
  ...
}
```

### Verify Internal Load Balancer Placement (Dual Stack)

Check dual stack subnet configuration with both IPv4 and IPv6:

```bash
az network vnet subnet show \
  --resource-group MC_byocnids_byocnids_southindia \
  --vnet-name aks-vnet-14676014 \
  --name dsapp-testing
```

**Output shows both IPv4 and IPv6 configurations:**
```json
{
  "addressPrefixes": [
    "10.225.0.0/24",
    "fd87:ef94:e938:40b4::/64"
  ],
  "ipConfigurations": [
    {
      "id": ".../frontendIPConfigurations/.../APP-TESTING",
      "resourceGroup": "MC_BYOCNIDS_..."
    },
    {
      "id": ".../frontendIPConfigurations/.../APP-TESTING-IPV6",
      "resourceGroup": "MC_BYOCNIDS_..."
    }
  ],
  ...
}
```

### Check Load Balancer Attachment to Subnet

Verify load balancer frontend IP configurations attached to subnet:

```bash
# IPv4 only
az network vnet subnet show -g MC_byocni_amit_eastus \
  -n app-testing \
  --vnet-name aks-vnet-17718742 \
  -o json | jq ".ipConfigurations[].id"

# Output:
# "/subscriptions/.../loadBalancers/KUBERNETES-INTERNAL/frontendIPConfigurations/..."
```

### Check Dual Stack Load Balancer Attachment

Query dual stack subnet for multiple frontend configurations:

```bash
az network vnet subnet show -g MC_byocnids_byocnids_southindia \
  -n dsapp-testing \
  --vnet-name aks-vnet-14676014 \
  -o json | jq ".ipConfigurations[].id"

# Output:
# "/subscriptions/.../loadBalancers/KUBERNETES-INTERNAL/frontendIPConfigurations/.../DSAPP-TESTING"
# "/subscriptions/.../loadBalancers/KUBERNETES-INTERNAL/frontendIPConfigurations/.../DSAPP-TESTING-IPV6"
```

### List Available IPs in Subnet

Check available IP addresses for load balancer allocation:

```bash
az network vnet subnet list-available-ips \
  --resource-group MC_byocni_amit_eastus \
  --vnet-name aks-vnet-17718742 \
  --name app-testing

# Output:
# [
#   "10.228.0.5",
#   "10.228.0.6",
#   "10.228.0.7",
#   "10.228.0.8",
#   "10.228.0.9"
# ]
```

### Azure Load Balancer DNS Name Annotation

Configure custom DNS names for load balancer services:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
  annotations:
    service.beta.kubernetes.io/azure-load-balancer-dns: "my-custom-dns"
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 8080
```

---

## CNI Configurations

### Azure CNI Configuration Options

Key configuration parameters for Azure CNI deployment:

- **Dynamic IP Assignment**: Pods receive IPs from virtual network
- **Overlay Mode**: Pods get IPs from overlay network (pod CIDR)
- **BYO CNI**: No built-in networking (bring your own CNI plugin)
- **Cilium Data Plane**: Advanced networking with Cilium eBPF

### CNI Configuration Best Practices

**Use Overlay networking when:**
- Large number of pods required (limited VNet IP space)
- Most pod communication is intra-cluster
- Advanced AKS features not needed

**Use VNet mode when:**
- Ample VNet IP address space available
- Heavy outbound cluster communication
- Resources outside cluster access pods directly
- Need advanced AKS features (virtual nodes)

**Sample Azure CNI configuration:**

```bash
# View current CNI configuration
az aks show -n cluster-name -g rg-name | grep -i cni
```

---

## ML Extensions and Specialized Deployments

### Azure ML Extension with Cilium

Deploy AKS cluster with Azure Machine Learning extension and Cilium networking:

```bash
az aks create \
  -n ml-cluster \
  -g ml-rg \
  -l eastus \
  --network-plugin azure \
  --network-dataplane cilium \
  --enable-managed-identity \
  --attach-acr <acr-name>

# Add ML extension
az k8s-extension create \
  --name azure-ml \
  --extension-type Microsoft.AzureML.Kubernetes \
  --scope cluster \
  --cluster-name ml-cluster \
  --resource-group ml-rg \
  --release-train stable
```

### Isovalent Enterprise Cilium Extension

Deploy Isovalent's enterprise-grade Cilium for advanced networking and security:

```bash
az aks create \
  -n isovalent-cluster \
  -g isovalent-rg \
  -l eastus \
  --network-plugin azure \
  --network-dataplane cilium

# Add Isovalent extension
az k8s-extension create \
  --name isovalent-cilium \
  --extension-type Microsoft.Isovalent.Cilium \
  --scope cluster \
  --cluster-name isovalent-cluster \
  --resource-group isovalent-rg
```

### Cluster Extensions and Add-ons

View and manage cluster extensions:

```bash
# List all extensions
az k8s-extension list --cluster-name <cluster> --resource-group <rg> --cluster-type managedClusters

# Show specific extension
az k8s-extension show --name <extension-name> --cluster-name <cluster> --resource-group <rg> --cluster-type managedClusters
```

---

## ARM-Based and Specialized Deployments

### ARM-Based Node Pool

Deploy ARM-based worker nodes for cost optimization:

```bash
az aks nodepool add \
  --resource-group <resource-group> \
  --cluster-name <cluster-name> \
  --name armnodepool \
  --node-vm-size Standard_D4ps_v5 \
  --os-type Linux
```

### RDMA/Infiniband with Cilium

High-performance computing setup with RDMA capabilities:

```bash
az aks create \
  -n rdma-hpc-cluster \
  -g rdma-rg \
  -l eastus \
  --network-plugin azure \
  --network-dataplane cilium \
  --node-vm-size Standard_HB120rs_v3 \
  --max-pods 250

# Deploy RDMA-aware workloads
kubectl apply -f rdma-workload.yaml
```

---

## Network Policy and Security

### Cilium Network Policies

Enable fine-grained network policies with Cilium:

```yaml
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: allow-frontend
spec:
  endpointSelector:
    matchLabels:
      app: backend
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: frontend
  - toEndpoints:
    - matchLabels:
        k8s:app: backend
    toPorts:
    - ports:
      - port: "8080"
        protocol: TCP
```

---

## Troubleshooting and Validation

### Validate Cilium Installation

Check Cilium pods and configuration:

```bash
kubectl get pods -n kube-system -l app=cilium

# Check Cilium status
kubectl exec -n kube-system <cilium-pod> -- cilium status
```

### Validate Load Balancer Configuration

Verify load balancer service creation:

```bash
kubectl get svc -o wide
kubectl describe svc <service-name>
```

### Check Network Policies

View applied network policies:

```bash
kubectl get networkpolicies -A
kubectl describe ciliumnp <policy-name>
```

---

## Notes

- Cilium provides advanced Layer 7 policy enforcement and observability
- Internal load balancers require proper subnet configuration
- Dual stack requires separate IPv4 and IPv6 subnets
- RDMA requires specialized VM SKUs and proper configuration
- Extensions integrate managed services (ML, Monitoring, Security)
- ARM-based nodes are cost-effective but have limited software support
