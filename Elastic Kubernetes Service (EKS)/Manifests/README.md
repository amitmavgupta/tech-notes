# EKS Manifests

Cluster configuration files, IAM policies, and helper scripts for eksctl.

## Highlights
- IAM policies for nodes and addons (`AmazonEKSWorkerNodePolicy.json`, `Amazon_EKS_CNI_IPv6_Policy.json`, etc.).
- Cluster specs for specialized scenarios: IPv6, Local Zones, Bottlerocket, Karpenter, and private clusters.
- Utility files such as `max-pod-calculator.sh` for determining pod density.

Use these manifests with `eksctl create cluster -f <file>` or attach the policies to IAM roles before cluster creation.
