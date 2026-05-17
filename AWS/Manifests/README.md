# AWS Manifests

Kubernetes manifest samples optimized for EKS experiments, load testing, and smoke tests. These manifests serve as starting points for validating cluster configurations, networking policies, and infrastructure setup.

## Files

### nginx-deployment.yaml

A production-ready Kubernetes Deployment manifest for nginx workloads on EKS.

**Components:**
- **Deployment**: Manages 80 replicas of nginx pods for load distribution
- **Container Image**: `public.ecr.aws/nginx/nginx:1.21` (from AWS ECR Public Gallery)
- **Service**: Creates a ClusterIP Service for internal DNS resolution
- **Port**: Container listens on port 80 (HTTP)

**Use Cases:**
- Load testing EKS cluster capacity
- Validating pod scheduling and node resource allocation
- Testing network policies and ingress configurations
- Smoke tests for cluster health and availability
- DNS resolution testing within the cluster

## Prerequisites

- EKS cluster is running and kubectl is configured
- Sufficient node capacity for 80 replicas (minimum CPU and memory requirements)
- AWS ECR Public access is available from your cluster nodes

## Usage

### Deploy the manifest

```bash
kubectl apply -f nginx-deployment.yaml
```

### Verify deployment status

```bash
kubectl get deployment nginx-deployment
kubectl get pods -l app=nginx
```

### Check service endpoints

```bash
kubectl get svc
kubectl get endpoints
```

### Test pod connectivity

```bash
# Access nginx from a pod within the cluster
kubectl run -it --rm debug --image=ubuntu --restart=Never -- bash
# Inside the pod:
curl http://nginx-deployment:80
```

### Scale the deployment

```bash
kubectl scale deployment nginx-deployment --replicas=40
```

### Clean up

```bash
kubectl delete -f nginx-deployment.yaml
```

## Network Policy Testing

Before applying network policies or load balancer configurations, validate that:
1. All nginx pods are running and ready
2. Service endpoints are properly registered
3. DNS resolution works within the cluster
4. Traffic flows as expected between pods

## Related Guides

For AWS CLI operations and Kubernetes integration, refer to:
- **AWS-CLI-Quick-Reference.md**: CloudFormation, IAM, and container registry operations
- **AWS-EC2-Kubernetes-Guide.md**: EC2 instance types for Kubernetes, EKS setup, and metadata retrieval
