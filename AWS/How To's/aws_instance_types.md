# AWS EC2 Instance Types for Kubernetes

## Find ARM-Based Instances in EC2

```bash
aws ec2 describe-instance-types \
  --filters "Name=current-generation,Values=true" \
  "Name=vcpu-info.default-vcpus,Values=2" \
  "Name=memory-info.size-in-mib,Values=4096" \
  "Name=processor-info.supported-architecture,Values=arm64" \
  --query "InstanceTypes[*].InstanceType"
```

Example output:
```json
[
    "t4g.medium",
    "c6g.large",
    "c7g.large",
    "c6gn.large",
    "c6gd.large"
]
```

## Node Architecture in Kubernetes

Check the architecture type of nodes in your cluster:

```bash
kubectl get no -L kubernetes.io/arch
```

Example output:
```
NAME                                                 STATUS   ROLES    AGE   VERSION                ARCH
ip-X-X-X-X.ap-northeast-2.compute.internal          Ready    <none>   57m   v1.29.12-eks-aeac579   arm64
ip-X-X-X-X.ap-northeast-2.compute.internal          Ready    <none>   57m   v1.29.12-eks-aeac579   arm64
```
