# Tech Notes

A living notebook of cloud, Kubernetes, networking, and performance references collected over years of hands-on work. Each folder captures either a provider-specific how-to, infrastructure manifest, troubleshooting aid, or curated set of external resources. Treat it like a field guide: clone it locally, explore by topic, and adapt the manifests to your environment.

## Repository map

| Area / Path | Highlights |
| --- | --- |
| `AWS/` | Service notes, architectures, and deployment walkthroughs for core AWS building blocks. |
| `Azure/` | Platform deep dives, CLI tips, and visuals covering networking, load balancers, encryption, and more. |
| `Azure Kubernetes Service (AKS)/` | Cluster manifests and comparisons of Azure CNI options (Cilium, BYO CNI, Kubenet, overlay) plus RDMA/InfiniBand and ML extensions. |
| `Azure-Utilities-Tools-created-with-Terraform/` | Terraform projects for repeatable Azure resources (Bastion, Ubuntu VMs, etc.). |
| `Blog-Manifests/` | YAML and Docker assets supporting published blog content. |
| `Bookmarks/` | Continuously updated list of articles, videos, and docs worth revisiting. |
| `Cheat-Sheets/` | Visual references for protocols, security, Linux, Kubernetes, and networking workflows (curated from public sources). |
| `Cilium/` | Policies, BGP configs, egress gateway samples, and other Cilium-first manifests. |
| `Cluster API/` | Cluster API templates and helper scripts. |
| `Elastic Kubernetes Service (EKS)/` & `Elastic Kubernetes Service-Anywhere/` | Manifests illustrating features such as Karpenter, IPv6-only clusters, BYO CNI, Local Zones, Private EKS, and on-prem EKS-A deployments. |
| `Google Kubernetes Engine (GKE)/` | GKE-specific cluster patterns and operational notes. |
| `Kubernetes/` | Generic manifests (deployments, dual-stack services, network policies) and command references. |
| `Mac/`, `Windows/`, `Tools/` | Platform tips, CLI tricks, and utilities that proved handy day-to-day. |
| `My-Blogs/` | Pointers to articles written across Medium and current/previous roles. |
| `OpenShift/`, `SDN/`, `Performance/` | OpenShift workflows, SDN diagrams, and performance experiments (SR-IOV, DPDK, poll-mode drivers). |

> Tip: Use `rg`, `grep`, or your editor's search to jump straight to a service, feature, or vendor.

## How to use these notes

- Browse by provider or technology depending on what you are building or debugging.
- Copy manifests into a scratch repo before applying them to production; customize region, instance type, CIDR blocks, and secrets.
- Many folders contain PNG/PDF diagrams—open them side-by-side with the markdown instructions for context.
- Several guides reference public blog posts; check `Blog-Manifests/` for the YAML or Dockerfile that matches the article slug.

## Keeping things fresh

1. Capture new learnings in the closest-matching folder, or create a short subfolder when a topic grows beyond a single file.
2. Prefer descriptive filenames (`eks-arm64-cluster.md` vs. `notes.md`).
3. Cross-link related notes (e.g., mention relevant cheat sheets or manifests) so future-you lands on the right artifact quickly.

## Contributing or adapting

- This repo is primarily a personal knowledge base, but feel free to fork it, trim what you need, and layer in your playbooks.
- If sharing back, include context (cloud, region/provider, tooling versions) so the next reader can reproduce your steps.
- Screenshots and cheat sheets belong to their original creators—double-check usage rights before redistributing outside this repo.

Happy building!