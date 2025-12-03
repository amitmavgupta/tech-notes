# EKS-A Manifests

Supporting resources for EKS Anywhere installs and AWS EKS Connector onboarding.

## Files
- `eksa-default.yaml`: Baseline EKS Anywhere cluster spec.
- `eks-connector*.yaml`: Resources needed to register clusters with the AWS console, including cluster roles and IAM policies.

Apply these manifests with `kubectl` against your management cluster or follow the AWS console instructions referenced in the how-to guides.
