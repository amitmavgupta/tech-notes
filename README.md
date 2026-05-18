# Tech Notes

A comprehensive, hands-on reference library covering cloud platforms, Kubernetes orchestration, networking architectures, and performance optimization. Built from years of practical experience across AWS, Azure, GCP, and on-premises environments, this repository serves as both a learning resource and a quick-reference guide for infrastructure professionals, platform engineers, and DevOps practitioners.

## Quick Start

1. **Clone and explore**: `git clone <repo-url> && cd tech-notes`
2. **Search content**: Use `rg`, `grep`, or your editor's search (Ctrl+F/Cmd+F) to find specific services, features, or vendors
3. **Copy & customize**: Manifests and configurations are ready to adapt—always validate in a non-production environment first
4. **Refer to diagrams**: PNG/PDF visuals complement markdown guides for better understanding

## Repository Structure

### Cloud Platforms

| Path | Focus |
| --- | --- |
| `AWS/` | Service architecture, deployment patterns, security best practices, and provider-specific configurations |
| `Azure/` | Platform capabilities, networking deep-dives, encryption, load balancing, and Azure-native features |
| `Google Kubernetes Engine (GKE)/` | GKE cluster patterns, workload scaling strategies, and operational procedures |

### Kubernetes & Container Orchestration

| Path | Focus |
| --- | --- |
| `Kubernetes/` | Core manifests (Deployments, StatefulSets, DaemonSets, Services, NetworkPolicies), RBAC examples, and kubectl workflows |
| `Azure Kubernetes Service (AKS)/` | CNI options (Cilium, BYO, Kubenet, overlay), advanced networking, RDMA/InfiniBand, and GPU/ML workload integration |
| `Elastic Kubernetes Service (EKS)/` | Karpenter, IPv6-only clusters, private clusters, Local Zones, and advanced networking patterns |
| `Elastic Kubernetes Service-Anywhere/` | On-premises EKS deployments and hybrid cluster management |
| `Cilium/` | eBPF-based networking, network policies, BGP configurations, egress gateways, and observability |
| `Cluster API/` | Infrastructure-agnostic cluster provisioning templates and management workflows |
| `OpenShift/` | OpenShift-specific deployments, operators, and enterprise Kubernetes workflows |

### Networking & Infrastructure

| Path | Focus |
| --- | --- |
| `SDN/` | Software-defined networking concepts, diagrams, overlay networks, and underlay architecture |
| `Performance/` | Performance tuning experiments, SR-IOV, DPDK, poll-mode drivers, and benchmarking approaches |

### Developer Tools & Utilities

| Path | Focus |
| --- | --- |
| `Tools/` | Essential CLI tools (crictl, terraform, helm, docker), system utilities, git workflows, and SSH tips |
| `Mac/` | macOS-specific configurations, Homebrew tips, and development environment setup |
| `Windows/` | Windows development tools, WSL2 guidance, and platform-specific utilities |

### Learning & Reference Materials

| Path | Focus |
| --- | --- |
| `Cheat-Sheets/` | Quick visual references for protocols, security models, Linux commands, and networking workflows |
| `Bookmarks/` | Curated collection of articles, videos, official documentation, and external resources |
| `Blog-Manifests/` | YAML, Dockerfile, and configuration files referenced in published blog articles |
| `My-Blogs/` | Links to published articles and technical writing across various platforms |

### Infrastructure-as-Code

| Path | Focus |
| --- | --- |
| `Azure-Utilities-Tools-created-with-Terraform/` | Reusable Terraform modules for Azure resources (Bastion hosts, virtual machines, networking) |
| `Blog-Manifests/` | Complete deployment examples and infrastructure blueprints from blog posts |

## Content Overview

### For Cloud Engineers
- Multi-cloud deployment patterns and cost optimization strategies
- Service interconnection, hybrid cloud, and disaster recovery architectures
- Identity & access management (IAM), encryption, and security controls
- Migration guides and best practices for legacy application modernization

### For Kubernetes Practitioners
- From basic Pod deployments to advanced StatefulSet patterns
- Multi-cluster networking and federation approaches
- CNI plugin deep-dives (Cilium, Flannel, Calico, Azure CNI)
- RBAC, network policies, and security hardening
- GitOps, observability, and operational runbooks

### For Network Engineers
- BGP, OSPF, and SDN fundamentals with configuration examples
- Overlay vs. underlay network design decisions
- High-performance networking (DPDK, SR-IOV, kernel tuning)
- Service mesh networking and observability patterns

### For DevOps & Platform Teams
- Infrastructure automation and Infrastructure-as-Code principles
- CI/CD pipeline design and GitOps workflows
- Monitoring, logging, and alerting architecture
- Disaster recovery and high availability strategies

## How to Use This Repository

### Browse by Interest
- **Cloud provider switching?** Start with the cloud platform folder (AWS, Azure, GKE) and compare networking options
- **Debugging a Kubernetes issue?** Check `Kubernetes/` for manifest examples, then the CNI-specific folder for advanced networking
- **Setting up tools?** Head to `Tools/` for installation and configuration guides
- **Need a quick reference?** Browse `Cheat-Sheets/` for protocol diagrams and command summaries

### Search Strategy
Use ripgrep or grep to jump directly to content:
```bash
rg "ServiceAccount" --type md              # Find RBAC examples
rg "LoadBalancer" --type md               # Locate networking patterns
rg "terraform" --type md                   # Find IaC examples
```

### Adapting Content for Production
1. **Review the full guide** before copying manifests
2. **Customize for your environment**: Replace placeholders (CIDR blocks, regions, instance types, secrets)
3. **Test in non-production first**: Validate security policies, networking configurations, and resource limits
4. **Document your changes**: Keep notes on what was adapted and why
5. **Version control**: Maintain your customized manifests in a separate repository

## Content Principles

- **Practical focus**: Every guide includes real-world considerations and gotchas
- **Current tooling**: Examples use current versions of Kubernetes, cloud SDKs, and containerization technologies
- **Community standards**: Follows CNCF best practices, Kubernetes API conventions, and industry security standards
- **Attributions**: References to original sources and authors are maintained throughout

## Contributing & Sharing

This repository is primarily a personal knowledge base. You can:
- **Fork & customize**: Take what's useful and adapt it to your organization's practices
- **Contribute improvements**: Submit pull requests with additional examples, corrections, or clarifications
- **Share context**: When adding content, include:
  - Tool versions and dates (when relevant)
  - Environment details (cloud region, Kubernetes distribution, OS version)
  - References to official documentation or related resources
  - Use cases and limitations

### Attribution Notes
- Diagrams, screenshots, and visualizations from third-party sources are attributed to original creators
- Always verify usage rights before redistributing content outside this repository
- This repository is provided for educational and professional reference purposes

## Quick Reference Links

- **Kubernetes Official Docs**: https://kubernetes.io/docs/
- **Cloud Platform Docs**: [AWS](https://docs.aws.amazon.com/) | [Azure](https://learn.microsoft.com/en-us/azure/) | [GCP](https://cloud.google.com/docs)
- **CNCF Projects**: https://www.cncf.io/projects/
- **Cilium Documentation**: https://docs.cilium.io/
- **Bookmarks folder**: See `Bookmarks/` for an extensive curated list

## License

See `LICENSE` file for licensing information. Content is provided as-is for educational and reference purposes.

---

**Happy learning & building!** 🚀

*Last updated: 2026-05-18*
