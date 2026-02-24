# AWS

Runbooks, references, and manifests for AWS networking, compute, & container workloads.

## Contents
- `How To's/`: CLI-driven walkthroughs for IAM, EC2, ECR, and VPC tasks such as `detach_iam_policies_role.md`, `ec2-instance-arm-based.md`, and `list-secondary-ips.md`.
- `Manifests/`: Lightweight Kubernetes resources (for example `nginx-deployment.yaml`) used to validate clusters provisioned through the runbooks.

## Usage
Pick the how-to that matches the task you are performing, provision or update the infrastructure, then apply the supporting manifests with `kubectl apply -f Manifests/<file>` to test networking end to end.
