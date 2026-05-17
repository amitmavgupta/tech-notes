# Google Kubernetes Engine (GKE)

Comprehensive guides for provisioning, managing, and operating Google Kubernetes Engine (GKE) clusters with advanced networking configurations.

---

## Quick Navigation

### 1. **GKE-Cluster-Provisioning.md**
Step-by-step guides for cluster creation with various networking scenarios:
- **Basic cluster creation**: Standard GKE cluster deployment
- **Dual-stack (IPv4 + IPv6)**: Deploy clusters with both IPv4 and IPv6 support
- **Multi-pod networking**: Advanced networking with Dataplane V2 and multiple network interfaces
- **Network configuration**: IP aliasing, pod CIDR planning, service CIDR management
- **Advanced networking features**: Dataplane V2, multi-networking interface support
- **Common configurations**: Production, development, and dual-stack deployment examples
- **Cluster verification**: Post-deployment validation and credential configuration

### 2. **GKE-Operations-Commands.md**
Essential gcloud CLI commands for cluster and infrastructure management:
- **gcloud configuration**: Project management and configuration
- **Cloud Shell operations**: SSH access, file transfers, interactive sessions
- **Cluster operations**: Credential management, cluster listing, deletion
- **Pod CIDR queries**: Network information retrieval and verification
- **Compute instances**: Compute Engine VM operations and file management
- **kubectl configuration**: Plugin installation and authentication setup
- **gcloud components**: Version management and component updates
- **Troubleshooting**: Common issues and resolution steps
- **Useful aliases**: Command shortcuts for productivity

---

## Quick Start

### 1. Create a GKE Cluster

Choose your deployment scenario:

```bash
# Basic cluster
gcloud container clusters create my-gke \
    --region us-central1

# Advanced: Dual-stack with Dataplane V2
gcloud container clusters create my-gke \
    --cluster-version=1.31 \
    --enable-dataplane-v2 \
    --enable-ip-alias \
    --stack-type=ipv4-ipv6 \
    --region us-central1
```

### 2. Connect to Your Cluster

Get credentials and verify connectivity:

```bash
# Get cluster credentials
gcloud container clusters get-credentials my-gke --region us-central1

# Verify connection
kubectl cluster-info
kubectl get nodes
```

### 3. Query Cluster Networking

Retrieve network configuration details:

```bash
# Get pod CIDR
gcloud container clusters describe my-gke --region us-central1 | grep podIpv4Cidr

# Get service CIDR
gcloud container clusters describe my-gke --region us-central1 | grep serviceCidr
```

### 4. Manage Cloud Resources

Work with Compute instances and Cloud Shell:

```bash
# List compute instances
gcloud compute instances list

# Access Cloud Shell
gcloud cloud-shell ssh

# Copy files from instances
gcloud compute scp instance-name://path/to/file ~/local/path/
```

---

## Common Deployment Scenarios

### Scenario 1: Production Cluster with High Availability

```bash
gcloud container clusters create prod-gke \
    --cluster-version=1.31 \
    --enable-dataplane-v2 \
    --enable-ip-alias \
    --enable-stackdriver-kubernetes \
    --addons HorizontalPodAutoscaling,HttpLoadBalancing \
    --region us-central1 \
    --num-nodes 3
```

### Scenario 2: Dual-Stack for IPv6 Migration

```bash
gcloud container clusters create dual-stack-gke \
    --enable-ip-alias \
    --stack-type=ipv4-ipv6 \
    --region us-west-2
```

### Scenario 3: Multi-Network Topology

```bash
gcloud container clusters create multi-net-gke \
    --cluster-version=1.31 \
    --enable-dataplane-v2 \
    --enable-ip-alias \
    --enable-multi-networking \
    --region us-central1
```

### Scenario 4: Development Cluster (Minimal Config)

```bash
gcloud container clusters create dev-gke \
    --enable-ip-alias \
    --region us-west1 \
    --num-nodes 1
```

---

## File Organization

```
Google Kubernetes Engine (GKE)/
├── README.md (this file - navigation hub)
├── GKE-Cluster-Provisioning.md (consolidated)
├── GKE-Operations-Commands.md (consolidated)
└── [original files - archived/reference]
```

---

## Key Concepts

**GKE**: Google Kubernetes Engine - fully managed Kubernetes on Google Cloud Platform

**Dataplane V2**: eBPF-based networking stack for improved performance and observability

**Dual-Stack**: Support for both IPv4 and IPv6 networking protocols simultaneously

**IP Aliasing**: Enable dynamic secondary IP ranges for pod networking

**Multi-Networking**: Support for pods with multiple network interfaces

**Pod CIDR**: Classless Inter-Domain Routing block for pod IP addresses

**Service CIDR**: CIDR block for Kubernetes Service IPs (default /20)

**gke-gcloud-auth-plugin**: Credential plugin extending kubectl with GKE-specific authentication

**Cloud Shell**: Temporary browser-based terminal with gcloud/kubectl pre-installed

**Compute Engine**: GCP infrastructure-as-a-service for virtual machines

---

## Usage Guidelines

1. **Consolidation**: Original individual `.md` files have been organized into 2 comprehensive guides
2. **Copy & Adapt**: All commands are ready to copy; adapt variables like `<cluster-name>`, `<region>`, `<project-id>`, etc.
3. **Prerequisites**: Ensure gcloud SDK is installed and you're authenticated before running commands
4. **Plugin Installation**: Must install `gke-gcloud-auth-plugin` for kubectl to work with GKE
5. **Network Planning**: Plan pod CIDR and service CIDR before cluster creation (determined at creation time)

---

## When to Use Each Resource

| Need | Resource |
| --- | --- |
| Create new cluster | GKE-Cluster-Provisioning.md |
| Query cluster information | GKE-Operations-Commands.md |
| Get pod/service CIDR | GKE-Operations-Commands.md |
| Configure dual-stack networking | GKE-Cluster-Provisioning.md |
| Enable multi-networking | GKE-Cluster-Provisioning.md |
| Manage compute instances | GKE-Operations-Commands.md |
| Cloud Shell operations | GKE-Operations-Commands.md |
| kubectl authentication | GKE-Operations-Commands.md |
| Troubleshooting | GKE-Operations-Commands.md |

---

## Integration with Other Platforms

- **AWS EKS**: Comparable guides available in AWS directory
- **Azure AKS**: Comprehensive AKS guides available in Azure Kubernetes Service (AKS) directory
- **Kubernetes**: Generic Kubernetes concepts and kubectl documentation

---

## Notes

- All commands use `gcloud` CLI (Google Cloud SDK v2.40+)
- `gke-gcloud-auth-plugin` is mandatory for recent GKE versions (1.26+)
- Pod CIDR and service CIDR are set at cluster creation time and cannot be changed later
- Regional clusters provide high availability across multiple zones
- IP aliasing is required for using pod secondary ranges
- Dataplane V2 requires Linux nodes and recent kernel versions
- Dual-stack clusters require dual-stack subnets in your VPC
- Multi-networking requires Dataplane V2 to be enabled
- File transfers via gcloud compute scp require SSH permissions
- Cloud Shell provides ephemeral storage (temporary); important files should be backed up

