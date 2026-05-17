# AKS How To's

Comprehensive guides for Azure Kubernetes Service (AKS) provisioning, operations, and advanced networking. All guides use Azure CLI commands and are organized for easy reference and automation.

---

## Quick Navigation

### 1. **AKS-Cluster-Provisioning.md**
Step-by-step cluster creation guides for various networking scenarios:
- **Azure CNI**: Basic CNI, multiple availability zones, custom network plugins
- **Azure CNI Powered by Cilium**: VNet mode, Overlay mode, Node subnet mode
- **Azure CNI with Azure Policy**: Governance and compliance integration
- **BYO CNI**: Custom CNI deployments with Azure Linux support
- **Kubenet with Calico**: Legacy networking with Calico policies
- **RDMA/Infiniband**: High-performance computing deployments
- **Specialized workloads**: ARM-based nodes for cost optimization

### 2. **AKS-Operations-Commands.md**
Essential commands for cluster management and monitoring:
- **Cluster management**: Create, delete, list, and update clusters
- **Network queries**: Service CIDR, Pod CIDR, subnet information
- **Kubernetes operations**: Node management, region/zone queries, uncordoning
- **Identity and access**: Managed identity creation and RBAC assignments
- **Private cluster access**: AKS Invoke for secure remote command execution
- **Konnectivity agents**: Deployment, verification, and troubleshooting
- **Add-ons and extensions**: Management, registration, and marketplace integration
- **Kube-proxy configuration**: Custom settings for BYO CNI deployments

### 3. **AKS-Advanced-Networking.md**
Advanced networking configuration and specialized deployments:
- **Cilium integration**: Ingress controller setup and configuration
- **Azure Load Balancer**: Internal/external LB management, DNS configuration
- **CNI configurations**: Best practices for overlay, VNet, and BYO CNI modes
- **ML extensions**: Azure ML and Isovalent Cilium enterprise deployments
- **RDMA/HPC**: High-performance computing with RDMA support
- **Network policies**: Cilium network policies for Layer 7 enforcement
- **Troubleshooting**: Validation and debugging commands

### 4. **CNI Configuration Reference**
Detailed CNI configurations for all networking modes:
- **Azure CNI (Default)**: Traditional Azure-native IPAM and port mapping
- **Azure CNI Overlay**: Private pod CIDR with nodes in VNet
- **Azure CNI with Dynamic IP**: Efficient IP allocation without per-node reservation
- **BYOCNI**: Custom CNI plugin configurations
- **Azure CNI Powered by Cilium**: Cilium with Azure IPAM integration
- **Kubenet**: Legacy bridge-based networking
- **Isovalent Enterprise Cilium**: Enterprise-grade Cilium from Azure Marketplace
- **Configuration comparison table**: IPAM types, plugins, and use cases

---

## Scenarios Covered

- ✅ Azure CNI flavors: base CNI, overlay, BYO CNI, Azure Linux, and Cilium-powered clusters
- ✅ Specialized deployments: RDMA/Infiniband, ARM-based workers, ingress integration, ML extensions
- ✅ Operations: Identity management, Konnectivity troubleshooting, add-ons/extensions, AKS Invoke for private clusters
- ✅ Add-ons and extensions: Preview feature registration, marketplace integration, lifecycle management
- ✅ Networking: Load balancer configuration, network policies, Cilium integration, dual-stack support
- ✅ Advanced configuration: Kube-proxy customization for BYO CNI

---

## Usage Guidelines

Each guide contains:
- **Azure CLI commands** ready to copy and adapt
- **Expected output** samples for validation
- **Prerequisites** for each scenario
- **Best practices** and considerations
- **Troubleshooting** sections where applicable

### Getting Started

1. Set your Azure subscription context: `az account set --subscription <subscription-id>`
2. Choose the relevant guide based on your deployment scenario
3. Review prerequisites and network planning sections
4. Copy and customize commands for your environment
5. Validate deployment using provided verification commands

### Example: Create Basic Azure CNI Cluster

```bash
# From AKS-Cluster-Provisioning.md - Basic Azure CNI Cluster section
az group create --name myResourceGroup --location eastus
az network vnet create -g myResourceGroup -n myVnet --address-prefixes 10.0.0.0/8
az network vnet subnet create -g myResourceGroup --vnet-name myVnet -n mySubnet --address-prefixes 10.240.0.0/16
az aks create -n myCluster -g myResourceGroup --network-plugin azure --vnet-subnet-id <subnet-id>
```

### Advanced: Create Cilium-Powered Cluster with Overlay Networking

```bash
# From AKS-Cluster-Provisioning.md - Overlay Mode section
az group create --name cilium-overlay-rg --location eastus
az aks create -n cilium-overlay -g cilium-overlay-rg -l eastus \
  --network-plugin azure \
  --network-plugin-mode overlay \
  --pod-cidr 192.168.0.0/16 \
  --network-dataplane cilium
```

### Manage Private Cluster

```bash
# From AKS-Operations-Commands.md - AKS Invoke section
az aks command invoke \
  --resource-group myRG \
  --name myPrivateCluster \
  --command "kubectl get pods -A"
```

### Understand CNI Configuration

```bash
# View CNI configuration details in cni-configs-AKS-CNI's.md
# All 7 CNI modes documented with JSON configurations:
# - Azure CNI (Default)
# - Azure CNI Overlay
# - Azure CNI Dynamic IP
# - BYO CNI
# - Azure CNI Powered by Cilium
# - Kubenet
# - Isovalent Enterprise Cilium
```

---

## Key Concepts

**Azure CNI**: Native Azure networking with pod IPs from VNet (production default)

**Cilium**: eBPF-based networking for advanced Layer 7 policies and observability

**Overlay Mode**: Pod IPs from dedicated CIDR (useful when VNet IPs are limited)

**BYO CNI**: Bring your own CNI plugin (e.g., Flannel, Calico, custom solutions)

**Kubenet**: Legacy networking with limited scalability (rarely recommended)

**AKS Invoke**: Secure command execution on private clusters via Azure API

**Konnectivity**: Built-in secure tunneling for private cluster communication

**Add-ons**: Azure-managed functionality with automatic patch management

**Extensions**: ARM-driven lifecycle management for advanced capabilities

**Kube-proxy**: Traffic distribution with IPVS or iptables backend (can be disabled)

**CNI Configurations**: Network plugin settings including IPAM type, port mapping, and debugging options

---

## Related Guides

- **Manifests**: Kubernetes deployment samples for testing cluster configurations
- **Extensions**: Azure-managed add-ons and extensions documentation

---

## Notes

- All commands assume Azure CLI v2.40+ is installed
- Ensure appropriate Azure RBAC permissions in your subscription
- IP address planning is critical for Azure CNI deployments
- Cilium requires Linux nodes only (no Windows support)
- Private clusters need AKS Invoke or dedicated connectivity solutions
- Production clusters should use multiple availability zones for HA
