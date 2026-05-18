# OpenShift

Comprehensive guides for deploying, managing, and operating Red Hat OpenShift clusters on Azure and AWS with enterprise-grade networking, security, and operational patterns.

---

## Directory Structure

### 📚 Getting Started

**[getting_started_with_openshift_local.md](getting_started_with_openshift_local.md)**
- Local OpenShift development setup with OpenShift Local
- Prerequisites and installation steps
- Basic cluster configuration and verification
- Use case: Development, testing, and learning

### 📖 Managed OpenShift Deployments

**[azure_redhat_openshift.md](azure_redhat_openshift.md)**
- Azure Red Hat OpenShift (ARO) cluster deployment on Azure
- Networking architecture (OVN-based with Geneve overlay)
- Resource provisioning and quota requirements
- Virtual network and subnet configuration
- Cluster creation and credential management
- Post-deployment verification with nodes and pods
- Use case: Production Azure-hosted OpenShift clusters

**[rosacliupgrade.md](rosacliupgrade.md)**
- ROSA (Red Hat OpenShift Service on AWS) CLI upgrade workflow
- Version management and CLI updates
- Use case: Keeping ROSA CLI current on development workstations

---

## Quick Start

### 1. Local Development with OpenShift Local

For learning or local testing:

```bash
# Follow: getting_started_with_openshift_local.md
# Download and configure OpenShift Local
# Start a single-node or multi-node cluster
crc start
# Retrieve cluster credentials
crc console --credentials
```

### 2. Deploy Azure Red Hat OpenShift (ARO)

For production Azure deployments:

```bash
# Follow: azure_redhat_openshift.md
# Set environment variables
AZR_RESOURCE_LOCATION=canadacentral
AZR_RESOURCE_GROUP=openshift
AZR_CLUSTER=cluster

# Create Azure resources
az group create --name $AZR_RESOURCE_GROUP --location $AZR_RESOURCE_LOCATION
az network vnet create --address-prefixes 10.0.0.0/22 --name "$AZR_CLUSTER-aro-vnet-$AZR_RESOURCE_LOCATION"

# Create and provision cluster
az aro create \
  --resource-group $AZR_RESOURCE_GROUP \
  --name $AZR_CLUSTER \
  --vnet "$AZR_CLUSTER-aro-vnet-$AZR_RESOURCE_LOCATION" \
  --pull-secret @$AZR_PULL_SECRET

# Access the cluster
az aro show --name $AZR_CLUSTER --resource-group $AZR_RESOURCE_GROUP -o tsv --query consoleProfile
```

### 3. Upgrade ROSA CLI

For AWS ROSA deployments:

```bash
# Follow: rosacliupgrade.md
rosa download rosa-client
tar xvf rosa-linux.tar.gz
sudo mv rosa /usr/local/bin/rosa
rosa version
```

---

## Common Deployment Scenarios

### Scenario 1: Production Azure Red Hat OpenShift Cluster

1. **Plan**: Define network CIDR blocks and resource quotas
2. **Provision**: Follow Azure prerequisites and create networking
3. **Deploy**: Execute ARO cluster creation with pull secret
4. **Verify**: Check nodes, pods, and console access
5. **Operate**: Monitor and manage via OpenShift console

### Scenario 2: Local Development Testing

1. **Install**: OpenShift Local on development workstation
2. **Configure**: Set cluster resources (CPU, memory)
3. **Start**: Launch cluster and retrieve credentials
4. **Test**: Deploy sample applications and validate networking
5. **Troubleshoot**: Use built-in diagnostics and logging

### Scenario 3: ROSA CLI Management

1. **Check**: Current ROSA CLI version installed
2. **Download**: Latest ROSA client from official mirror
3. **Update**: Extract and install to system binary path
4. **Verify**: Confirm version and CLI functionality

---

## File Organization

```
OpenShift/
├── README.md (this file - navigation hub)
├── azure_redhat_openshift.md (ARO deployment guide)
├── rosacliupgrade.md (ROSA CLI upgrade guide)
└── getting_started_with_openshift_local.md (local dev setup)
```

---

## Key Concepts

**ARO**: Azure Red Hat OpenShift - fully managed OpenShift on Azure

**ROSA**: Red Hat OpenShift Service on AWS - managed OpenShift on AWS

**OpenShift Local**: Single/multi-node development environment for local testing

**OVN**: Open Virtual Network - OpenShift's default container networking overlay

**Geneve**: Generic Network Virtualization Encapsulation protocol (replaces VXLAN for OVN)

**Pull Secret**: Red Hat container registry credentials required for cluster deployment

**CNI**: Container Network Interface - networking plugin for pod communication

**Control Plane**: OpenShift API server and etcd (typically 3 nodes)

**Worker Nodes**: Compute nodes running application workloads

---

## Usage Guidelines

1. **Choose your platform**: AWS (ROSA) or Azure (ARO)
2. **Local testing first**: Use OpenShift Local to understand concepts
3. **Production deployment**: Follow ARO or ROSA production guides
4. **Keep tooling current**: Regularly update ROSA CLI and OpenShift client
5. **Copy & Adapt**: All commands are ready to copy; adapt variables for your environment
6. **Validate**: Expected outputs and verification steps provided for all major commands

---

## When to Use Each Resource

| Need | Resource |
| --- | --- |
| Local development | getting_started_with_openshift_local.md |
| Azure production cluster | azure_redhat_openshift.md |
| ROSA CLI updates | rosacliupgrade.md |
| Networking architecture | azure_redhat_openshift.md (CNI section) |
| Cluster verification | azure_redhat_openshift.md (nodes/pods section) |

---

## Integration with Other Platforms

- **AWS**: ROSA (Red Hat OpenShift Service on AWS) guides
- **Azure**: ARO (Azure Red Hat OpenShift) comprehensive guides
- **Kubernetes**: OpenShift extends Kubernetes with enterprise features
- **Cloud platforms**: AWS, Azure documentation for cloud-specific integration

---

## Notes

- All Azure CLI commands use v2.40+ format
- ROSA CLI mirrors are hosted at official Red Hat sites
- OpenShift Local requires virtualization support (KVM, Hyper-V, or Apple Silicon)
- ARO minimum quota: 40 cores per subscription for cluster creation
- Default Azure subscription quota is 10 cores (requires quota increase)
- OVN uses Geneve overlay networking (not VXLAN)
- Pull secrets required for container registry access
- ARO automatically manages control plane nodes (not user-accessible)
- Cluster credentials persist in Azure key vault
- Production clusters should be deployed across multiple availability zones
- Consider network policies and RBAC for security hardening
- Refer to official Red Hat documentation for latest feature support
