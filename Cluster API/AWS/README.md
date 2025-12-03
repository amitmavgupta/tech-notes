# Cluster API AWS Assets

Files required to bootstrap or expand Cluster API managed clusters on AWS.

## Files
- `control-plane-manager-role.yaml`: IAM role policy for the control plane manager.
- `eks_config.yaml`: Example workload cluster manifest tailored to EKS-style networking.

Apply the IAM policy first, then feed the config file to `clusterctl generate cluster -f eks_config.yaml`.
