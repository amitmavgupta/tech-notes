# Azure Kubernetes Service (AKS)

Comprehensive guides, reference documentation, architecture notes, and configuration manifests for deploying, managing, and operating Azure Kubernetes Service (AKS) clusters with multiple CNI options and networking scenarios.

---

## Directory Structure

### 📚 How To's

Step-by-step deployment and configuration guides for various AKS scenarios, organized into three consolidated resources:

**[AKS-Cluster-Provisioning.md](How%20To's/AKS-Cluster-Provisioning.md)**
- Azure CNI (basic, multi-AZ, custom network plugins)
- Azure CNI Powered by Cilium (VNet mode, Overlay mode, Node subnet mode)
- Azure CNI with Azure Policy (governance and compliance)
- BYO CNI (custom CNI deployments with Azure Linux)
- Kubenet with Calico (legacy networking)
- RDMA/Infiniband specialized deployments
- ARM-based node pools for cost optimization
- Cluster management commands (create, delete, update, list)

**[AKS-Operations-Commands.md](How%20To's/AKS-Operations-Commands.md)**
- Cluster management and monitoring commands
- Network queries (Service CIDR, Pod CIDR, subnet information)
- Kubernetes node operations and verification
- Identity and access management (managed identities, RBAC)
- Private cluster access via AKS Invoke (VPN-less tunneling)
- Konnectivity agents (deployment, verification, troubleshooting)
- Add-ons and extensions management (registration, marketplace integration)
- Kube-proxy configuration for BYO CNI deployments

**[AKS-Advanced-Networking.md](How%20To's/AKS-Advanced-Networking.md)**
- Cilium ingress controller setup
- Azure Load Balancer configuration (IPv4 and Dual Stack)
- CNI configuration best practices
- ML extensions and Isovalent Cilium enterprise deployments
- RDMA/HPC high-performance computing setups
- Cilium network policies for Layer 7 enforcement
- Troubleshooting and validation commands

### 📖 Notes

Architecture documentation, design patterns, and conceptual explanations:

**[networking_considerations_aks.md](Notes/networking_considerations_aks.md)**
- Design checklist for AKS network planning
- CNI mode selection guidelines
- IP address planning considerations
- Networking trade-offs and best practices
- Reference for architecture discussions

**[azure_nodes_vms.md](Notes/azure_nodes_vms.md)**
- Azure VM node architecture details
- Node provisioning and lifecycle
- Resource allocation and constraints
- Performance considerations

**[azure_nodes_vms.png](Notes/azure_nodes_vms.png)**
- Topology visualization diagram
- Node and networking architecture illustration
- Use for stakeholder presentations and onboarding

### 📋 CNI Configuration Reference

Located in How To's directory: **cni-configs-AKS-CNI's.md**

Detailed JSON configurations for all 7 CNI modes:
- Azure CNI (Default) with azure-vnet-ipam
- Azure CNI Overlay with pod CIDR
- Azure CNI with Dynamic IP allocation
- BYOCNI custom plugin configurations
- Azure CNI Powered by Cilium
- Kubenet with bridge networking
- Isovalent Enterprise Cilium

---

## Quick Start

### 1. Plan Your AKS Deployment

Start with architecture and networking considerations:

```bash
# Review design checklist and network planning
# See: Notes/networking_considerations_aks.md

# Understand your CNI choice
# Azure CNI: Production default, pod IPs from VNet
# Cilium: Advanced policies, observability, eBPF dataplane
# Kubenet: Legacy, limited scalability
# BYO CNI: Custom requirements
```

### 2. Deploy AKS Cluster

Choose the deployment scenario and follow the guide:

```bash
# Basic Azure CNI Cluster
# From: How To's/AKS-Cluster-Provisioning.md
az group create --name myResourceGroup --location eastus
az network vnet create -g myResourceGroup -n myVnet --address-prefixes 10.0.0.0/8
az network vnet subnet create -g myResourceGroup --vnet-name myVnet --name mySubnet --address-prefixes 10.240.0.0/16
az aks create -n myCluster -g myResourceGroup --network-plugin azure --vnet-subnet-id <subnet-id>

# Advanced: Cilium-Powered Cluster with Overlay Networking
az aks create -n cilium-cluster -g myResourceGroup -l eastus \
  --network-plugin azure \
  --network-plugin-mode overlay \
  --pod-cidr 192.168.0.0/16 \
  --network-dataplane cilium
```

### 3. Manage Cluster Operations

Execute management and operational tasks:

```bash
# Query cluster and network information
# From: How To's/AKS-Operations-Commands.md
az aks show -n myCluster -g myResourceGroup | grep -i serviceCidr
kubectl get nodes -o custom-columns=NAME:'{.metadata.name}',REGION:'{.metadata.labels.topology\.kubernetes\.io/region}'

# Access private clusters without VPN
# From: How To's/AKS-Operations-Commands.md - AKS Invoke section
az aks command invoke \
  --resource-group myResourceGroup \
  --name myPrivateCluster \
  --command "kubectl get pods -A"
```

### 4. Configure Advanced Networking

Set up advanced networking features:

```bash
# Cilium ingress controller
# From: How To's/AKS-Advanced-Networking.md
kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master"

# Internal load balancer with annotations
# From: How To's/AKS-Advanced-Networking.md
kubectl apply -f internal-lb-service.yaml

# Network policies for security
# From: How To's/AKS-Advanced-Networking.md
kubectl apply -f cilium-network-policy.yaml
```

### 5. Review Design Trade-offs

Understand your architecture choices with stakeholders:

```bash
# Review topology diagram
# See: Notes/azure_nodes_vms.png

# Read conceptual explanations
# See: Notes/networking_considerations_aks.md
# Understand IP address planning, CNI mode trade-offs, and best practices
```

---

## Common Deployment Scenarios

### Scenario 1: Production Cluster with High Availability

```bash
# Use: AKS-Cluster-Provisioning.md - Multiple Availability Zones
az aks create \
    --resource-group prodRG \
    --name prodCluster \
    --vm-set-type VirtualMachineScaleSets \
    --load-balancer-sku standard \
    --node-count 3 \
    --zones 1 2 3
```

### Scenario 2: Large-Scale Cluster with Limited VNet Space

```bash
# Use: AKS-Cluster-Provisioning.md - Overlay Mode
az aks create \
  -n overlay-cluster -g myRG -l eastus \
  --network-plugin azure \
  --network-plugin-mode overlay \
  --pod-cidr 192.168.0.0/16
```

### Scenario 3: Advanced Networking with Cilium

```bash
# Use: AKS-Cluster-Provisioning.md - Azure CNI Powered by Cilium
az aks create \
  -n cilium-cluster -g myRG -l eastus \
  --network-plugin azure \
  --network-dataplane cilium
```

### Scenario 4: Custom CNI (BYO CNI)

```bash
# Use: AKS-Cluster-Provisioning.md - BYOCNI
az aks create \
  -n byocni-cluster -g myRG -l eastus \
  --network-plugin none \
  --kubernetes-version 1.35
# Then install your preferred CNI plugin
```

### Scenario 5: Private Cluster Access

```bash
# Use: AKS-Operations-Commands.md - AKS Invoke
az aks command invoke \
  --resource-group myRG \
  --name privateCluster \
  --command "kubectl get pods -A"
```

---

## File Organization

```
Azure Kubernetes Service (AKS)/
├── README.md (this file - navigation hub)
├── How To's/
│   ├── README.md (quick reference guide)
│   ├── AKS-Cluster-Provisioning.md (consolidated)
│   ├── AKS-Operations-Commands.md (consolidated)
│   ├── AKS-Advanced-Networking.md (consolidated)
│   ├── cni-configs-AKS-CNI's.md (CNI reference)
│   └── [original files - archived/reference]
└── Notes/
    ├── README.md (architecture guide)
    ├── networking_considerations_aks.md (design checklist)
    ├── azure_nodes_vms.md (node architecture)
    └── azure_nodes_vms.png (topology diagram)
```

---

## Key Concepts

**AKS**: Azure Kubernetes Service - fully managed Kubernetes on Azure

**Azure CNI**: Native Azure networking with pod IPs from VNet (production default)

**Cilium**: eBPF-based networking for advanced Layer 7 policies and observability

**Overlay Mode**: Pod IPs from dedicated CIDR (useful when VNet IPs are limited)

**BYO CNI**: Bring your own CNI plugin (e.g., Flannel, Calico, custom solutions)

**Kubenet**: Legacy networking with bridge and host-local IPAM (limited scalability)

**AKS Invoke**: Secure command execution on private clusters via Azure API (VPN-less)

**Konnectivity**: Built-in secure tunneling for private cluster communication

**Add-ons**: Azure-managed functionality with automatic patch management

**Extensions**: ARM-driven lifecycle management for advanced capabilities

**IPAM**: IP Address Management - determines how pod IPs are allocated

**Kube-proxy**: Traffic distribution component (IPVS or iptables backend)

**CNI Configurations**: Network plugin settings including IPAM type, port mapping, debugging

---

## Workflow: From Planning to Production

1. **Plan** → Review `Notes/networking_considerations_aks.md` for design decisions
2. **Understand** → Reference `Notes/azure_nodes_vms.png` for architecture
3. **Deploy** → Follow scenario from `How To's/AKS-Cluster-Provisioning.md`
4. **Operate** → Use commands from `How To's/AKS-Operations-Commands.md`
5. **Optimize** → Apply advanced config from `How To's/AKS-Advanced-Networking.md`
6. **Troubleshoot** → Check validation commands in advanced guide

---

## Usage Guidelines

1. **Consolidation**: Original 20+ individual `.md` files have been organized into 3 comprehensive guides plus notes
2. **Navigation**: Use this README as a hub to find the right resource
3. **Copy & Adapt**: All commands are ready to copy; adapt variables like `<resource-group>`, `<cluster-name>`, etc.
4. **Validation**: Expected output samples are provided for verification
5. **Best Practices**: Each guide includes recommendations for production deployments

---

## When to Use Each Resource

| Need | Resource |
| --- | --- |
| Basic deployment command | AKS-Cluster-Provisioning.md |
| Network troubleshooting | AKS-Operations-Commands.md |
| Cilium configuration | AKS-Advanced-Networking.md |
| Design decisions | Notes/networking_considerations_aks.md |
| Architecture explanation | Notes/azure_nodes_vms.png |
| CNI JSON configuration | cni-configs-AKS-CNI's.md |
| Private cluster access | AKS-Operations-Commands.md (AKS Invoke) |
| Add-ons/Extensions | AKS-Operations-Commands.md |

---

## Integration with Other Documentation

- **AWS**: Similar comprehensive guides for EKS (Elastic Kubernetes Service)
- **Kubernetes**: Generic Kubernetes concepts and kubectl commands
- **Azure**: Azure-specific networking, identity, and resource management

---

## Notes

- All commands assume Azure CLI v2.40+ is installed
- Ensure appropriate Azure RBAC permissions in your subscription
- IP address planning is critical for Azure CNI deployments
- Cilium requires Linux nodes only (no Windows support)
- Private clusters need AKS Invoke or dedicated connectivity solutions
- Production clusters should use multiple availability zones for HA
- The CNI configuration determines networking behavior and must be chosen during cluster creation
- Add-ons are automatically patched; extensions follow user-defined schedules
- Konnectivity agents are built-in and don't require separate installation
- Preview features require explicit registration before use
