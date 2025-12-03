# Azure Kubernetes Service (AKS)

Reference material for planning, deploying, and operating AKS clusters with multiple CNI options.

## Contents
- `How To's/`: detailed cluster builds (Azure CNI, overlay, BYO CNI, Cilium, RDMA/Infiniband) driven via Azure CLI.
- `Manifests/`: supplemental artifacts such as `disable_kube_proxy_byocni.json` used to tune kube-proxy behavior when providing your own dataplane.
- `Notes/`: conceptual explanations and architecture diagrams about Azure CNI internals and node networking.

## Usage
Start from the how-to scenario that matches your requirement, include the manifest when prompted, then review the notes to explain design trade-offs to stakeholders.
