# AWS Manifests

Kubernetes samples optimized for EKS experiments and smoke tests.

## Files
- `nginx-deployment.yaml`: Creates an `apps/v1` Deployment plus ClusterIP Service for a basic nginx workload.

## Usage
1. `kubectl apply -f nginx-deployment.yaml`
2. Validate pods and service endpoints before exercising network policies or load balancer settings.
