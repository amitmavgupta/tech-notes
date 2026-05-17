# GKE Cluster Provisioning Guide

Comprehensive guide for provisioning Google Kubernetes Engine (GKE) clusters with various networking configurations and advanced features.

---

## Prerequisites

- `gcloud` CLI installed and configured
- GCP project set up with appropriate permissions
- Network and subnet resources created beforehand
- `kubectl` installed locally

---

## Basic GKE Cluster Creation

### Create Standard GKE Cluster

```bash
gcloud container clusters create <cluster-name> \
    --region <region> \
    --project <project-id>
```

---

## Dual-Stack (IPv4 + IPv6) Cluster

### Create Dual-Stack GKE Cluster

Deploy a GKE cluster with both IPv4 and IPv6 networking support:

```bash
gcloud container clusters create tme-dual-stack \
    --enable-ip-alias \
    --stack-type=ipv4-ipv6 \
    --network=tme-dual-stack \
    --region us-west-2 \
    --subnetwork=tme-dual-stack
```

**Parameters:**
- `--enable-ip-alias`: Enable IP aliasing for flexible IP management
- `--stack-type=ipv4-ipv6`: Enable dual-stack (IPv4 and IPv6) networking
- `--network`: Existing VPC network name
- `--subnetwork`: Existing subnet within the VPC
- `--region`: GCP region for cluster deployment

**Prerequisites:**
- Network and subnet should have been created beforehand
- Dual-stack subnet must support both IPv4 and IPv6 CIDR blocks

**Use cases:**
- Future-proof infrastructure with IPv6 support
- Migration planning from IPv4 to IPv6
- Multi-protocol service deployment

---

## Multi-Pod Networking

### Create Cluster with Multi-Networking Support

Deploy a GKE cluster with Dataplane V2 and multi-pod networking capabilities:

```bash
gcloud container clusters create test-gke \
    --cluster-version=1.31 \
    --enable-dataplane-v2 \
    --enable-ip-alias \
    --enable-multi-networking
```

**Parameters:**
- `--enable-dataplane-v2`: Enable advanced eBPF-based dataplane for improved performance
- `--enable-ip-alias`: Enable IP aliasing
- `--enable-multi-networking`: Support multiple network interfaces per pod
- `--cluster-version`: Kubernetes version (1.31 or later recommended)

**Benefits:**
- Advanced networking capabilities with eBPF dataplane
- Support for multiple network interfaces per pod
- Improved network performance and observability

**Use cases:**
- High-performance networking workloads
- Advanced multi-network topologies
- Network-intensive applications

---

## Network Configuration Best Practices

### IP Aliasing

IP aliasing in GKE enables:
- Dynamic secondary IP ranges for pod networking
- Flexible pod IP allocation
- Better IP address utilization

**Enable during cluster creation:**
```bash
gcloud container clusters create <cluster-name> \
    --enable-ip-alias \
    --network=<network-name> \
    --subnetwork=<subnet-name>
```

### Pod CIDR Planning

Plan your pod CIDR blocks before cluster creation:

```bash
# Recommended pod CIDR sizes:
# Small cluster (up to 64 nodes): /24 per node, /19 total
# Medium cluster (65-256 nodes): /24 per node, /17 total
# Large cluster (257+ nodes): /24 per node, /16 total
```

### Service CIDR Configuration

```bash
gcloud container clusters create <cluster-name> \
    --services-ipv4-cidr <CIDR-block> \
    --region <region>
```

**Default:** If not specified, GCP automatically assigns a /20 service CIDR

---

## Advanced Networking Features

### Dataplane V2

Dataplane V2 provides:
- eBPF-based networking stack
- Enhanced observability
- Improved performance for high-throughput workloads
- Better resource efficiency

**Enable Dataplane V2:**
```bash
gcloud container clusters create <cluster-name> \
    --enable-dataplane-v2 \
    --region <region>
```

**Requirements:**
- GKE cluster version 1.27 or later
- Linux nodes only
- Sufficient kernel version supporting eBPF

### Multi-Networking Interface Support

Multi-networking allows pods to attach multiple network interfaces:

```bash
gcloud container clusters create <cluster-name> \
    --enable-multi-networking \
    --enable-dataplane-v2 \
    --region <region>
```

**Use cases:**
- Network service chaining
- Multi-path networking
- Advanced network topologies
- Load balancing across multiple networks

---

## Cluster Verification

### Verify Cluster Creation

```bash
gcloud container clusters describe <cluster-name> \
    --region <region> \
    --project <project-id>
```

### Get Cluster Credentials

Configure kubectl to access your cluster:

```bash
gcloud container clusters get-credentials <cluster-name> \
    --region <region> \
    --project <project-id>
```

### Verify Cluster Status

```bash
kubectl cluster-info
kubectl get nodes
```

---

## Common Cluster Configurations

### Production Cluster with HA and Advanced Networking

```bash
gcloud container clusters create prod-gke \
    --cluster-version=1.31 \
    --enable-dataplane-v2 \
    --enable-ip-alias \
    --enable-multi-networking \
    --enable-stackdriver-kubernetes \
    --addons HorizontalPodAutoscaling,HttpLoadBalancing \
    --region us-central1 \
    --num-nodes 3
```

### Development Cluster with Minimal Configuration

```bash
gcloud container clusters create dev-gke \
    --cluster-version=1.31 \
    --enable-ip-alias \
    --region us-west1 \
    --num-nodes 1
```

### Dual-Stack Production Cluster

```bash
gcloud container clusters create prod-dual-stack \
    --stack-type=ipv4-ipv6 \
    --enable-ip-alias \
    --enable-dataplane-v2 \
    --region us-central1 \
    --num-nodes 3
```

---

## Notes

- All commands use `gcloud` CLI (Google Cloud SDK v2.40+)
- Network and subnet must be pre-created before cluster provisioning
- IP address planning is critical for cluster scaling
- Dataplane V2 recommended for production workloads
- Dual-stack clusters require dual-stack subnet support
- Multi-networking requires Dataplane V2 enabled
- Regional clusters provide high availability by default
