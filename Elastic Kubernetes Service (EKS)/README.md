# Elastic Kubernetes Service (EKS)

Guides, IAM policies, and cluster specifications for building and testing Amazon EKS.

## Contents
- `How To's/`: Runbooks for eksctl operations, upgrades, CoreDNS scaling, pod identity, Bottlerocket nodes, and more.
- `Manifests/`: IAM policies plus cluster configuration YAML/JSON covering node groups, IPv6, Local Zones, Karpenter, and specialty workloads.
- `max-pod-calculator.sh`: Helper script for planning pod density per instance type.

## Quick start
Use eksctl to stand up clusters with any manifest in this folder:
```
eksctl create cluster -f <filename.yaml>
```

Clusters that rely on Cilium can be prepared with:
```
helm install cilium cilium/cilium --version 1.17.4 \
  --namespace kube-system \
  --set eni.enabled=true \
  --set ipam.mode=eni \
  --set egressMasqueradeInterfaces=eth+ \
  --set routingMode=native
```

Adjust values (version, flags) to match the release you are targeting before running the commands.
