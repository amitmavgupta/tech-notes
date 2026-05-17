# AWS

Comprehensive guides, reference documentation, and Kubernetes manifests for AWS networking, compute, and container workloads on EKS (Elastic Kubernetes Service).

---

## Directory Structure

### 📚 How To's

CLI-driven reference guides for AWS operations, organized into two consolidated resources:

**[AWS-CLI-Quick-Reference.md](How%20To's/AWS-CLI-Quick-Reference.md)**
- IAM and authentication operations (role switching, caller identity)
- CloudFormation stack management
- Route 53 hosted zone queries
- Container Registry (ECR) operations
- Network utilities (IPv4 prefixes, secondary IPs, availability zones)
- AWS Quota Checker commands
- gcloud component management

**[AWS-EC2-Kubernetes-Guide.md](How%20To's/AWS-EC2-Kubernetes-Guide.md)**
- EC2 instance type discovery (ARM-based instances, network bandwidth)
- EC2 instance information retrieval via CLI and Kubernetes
- Kubernetes node architecture verification
- EKS cluster operations (EBS CSI driver setup)
- EC2 metadata retrieval (IMDSv2 token-based access)
- Region and availability zone queries
- Instance naming and identification

### 📦 Manifests

Lightweight Kubernetes manifests for testing and validation:

**[nginx-deployment.yaml](Manifests/nginx-deployment.yaml)**
- Production-ready nginx Deployment with 80 replicas
- ClusterIP Service for internal DNS resolution
- Container image from AWS ECR Public Gallery
- Use cases: Load testing, pod scheduling validation, network policy testing, smoke tests

**[README.md](Manifests/README.md)**
- Comprehensive deployment guide
- Prerequisites and prerequisites checking
- Usage instructions (deploy, verify, scale, cleanup)
- Network policy testing guidance
- Cross-references to AWS guides

---

## Quick Start

### 1. Perform AWS Operations

Choose the relevant guide based on your task:

```bash
# IAM and CloudFormation operations
# See: How To's/AWS-CLI-Quick-Reference.md
aws sts get-caller-identity
aws cloudformation list-stacks

# EC2 instance queries and Kubernetes integration
# See: How To's/AWS-EC2-Kubernetes-Guide.md
aws ec2 describe-instance-types --filters "Name=processor-info.supported-architecture,Values=arm64"
kubectl get nodes -L kubernetes.io/arch
```

### 2. Validate Cluster Deployment

Deploy test workloads using the provided manifests:

```bash
# Deploy nginx workload
kubectl apply -f Manifests/nginx-deployment.yaml

# Verify deployment
kubectl get deployment nginx-deployment
kubectl get pods -l app=nginx

# Scale if needed
kubectl scale deployment nginx-deployment --replicas=40

# Test connectivity within cluster
kubectl run -it --rm debug --image=ubuntu --restart=Never -- bash
# Inside pod: curl http://nginx-deployment:80
```

### 3. Test Network Policies and Load Balancer

Before applying network policies or load balancer configurations:

```bash
# Verify all pods are running
kubectl get pods -l app=nginx

# Check service endpoints
kubectl get svc

# Test DNS resolution
kubectl exec -it <nginx-pod> -- nslookup kubernetes.default
```

---

## Common Workflows

### Setup EKS Cluster and Validate

1. **Provision cluster** with desired networking (refer to AWS documentation or infrastructure-as-code)
2. **Query cluster details** using AWS CLI commands from guides
3. **Deploy nginx manifest** to validate cluster health
4. **Test networking** with curl or network policies
5. **Verify pod scheduling** across nodes and availability zones

### Troubleshoot EC2 Instance Issues

1. **Find instance details** using EC2 instance name/ID queries
2. **Check architecture compatibility** for pod deployments
3. **Query available bandwidth** for workload requirements
4. **Retrieve metadata** for configuration or automation
5. **Cross-reference** Kubernetes node information

### Manage IAM and CloudFormation

1. **Switch AWS profiles** for multi-account operations
2. **Query infrastructure** via CloudFormation and Route 53
3. **Manage container registries** (ECR) for image storage
4. **Check resource quotas** using AWS Quota Checker

---

## File Organization

```
AWS/
├── README.md (this file)
├── How To's/
│   ├── README.md (navigation guide)
│   ├── AWS-CLI-Quick-Reference.md (consolidated)
│   ├── AWS-EC2-Kubernetes-Guide.md (consolidated)
│   └── [original files - archived/reference]
└── Manifests/
    ├── README.md (deployment guide)
    └── nginx-deployment.yaml (test workload)
```

---

## Key Concepts

**EKS**: Amazon Elastic Kubernetes Service - managed Kubernetes on AWS

**EC2**: Elastic Compute Cloud - scalable cloud computing instances

**ECR**: Elastic Container Registry - Docker-compatible container image storage

**CloudFormation**: Infrastructure-as-Code service for AWS resource automation

**Route 53**: Managed DNS service for domain registration and health checking

**IAM**: Identity and Access Management for AWS security and permissions

**IMDSv2**: Instance Metadata Service v2 - token-based secure metadata access

**Quota Checker**: Tool to verify resource limits and usage in your AWS account

---

## Usage Guidelines

1. **Consolidation**: Original individual `.md` files have been merged into two main guides:
   - `AWS-CLI-Quick-Reference.md` for general AWS operations
   - `AWS-EC2-Kubernetes-Guide.md` for Kubernetes and EC2 integration

2. **Cross-Reference**: Both guides reference each other for related tasks

3. **Copy & Adapt**: All commands are ready to copy; adapt variables like `<resource-group>`, `<cluster-name>`, etc.

4. **Validation**: Expected output samples are provided for command verification

5. **Manifests**: Use provided Kubernetes manifests to test cluster configurations

---

## Related Documentation

- **Azure Kubernetes Service (AKS)**: Similar comprehensive guides for Azure AKS clusters
- **Elastic Kubernetes Service (EKS)**: AWS managed Kubernetes service documentation
- **Cluster API**: Infrastructure-agnostic Kubernetes cluster provisioning

---

## Notes

- All commands use AWS CLI v2 format
- Manifests are optimized for EKS but compatible with any Kubernetes cluster
- IAM permissions and AWS credentials must be configured before running CLI commands
- IMDSv2 is recommended for token-based metadata access
- Production clusters should use multiple availability zones for high availability
- Refer to official AWS documentation for detailed parameter explanations
- The nginx manifest includes 80 replicas for load testing; adjust as needed
