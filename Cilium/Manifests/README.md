# Cilium Manifests

Supporting Kubernetes resources for Cilium features.

## Categories
- AKS-focused egress gateway policies (`aks_egressgw_policy*.yaml`) and ingress annotations.
- EKS assets such as `eks_bgp_config_aws_route_server.yaml` and `eks_egressgw_policy.yaml`.
- GKE and generic samples including `gke-cilium-install-values.yaml`, `cnp_*` policies, and gateway API annotations.

Apply these manifests with `kubectl` or feed them into Helm/custom automation exactly as referenced by the how-to guides.
