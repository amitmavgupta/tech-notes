# Tech Notes

A comprehensive, hands-on reference library covering cloud platforms, Kubernetes orchestration, networking architectures, and performance optimization. Built from years of practical experience across AWS, Azure, GCP, and on-premises environments, this repository serves as both a learning resource and a quick-reference guide for infrastructure professionals, platform engineers, and DevOps practitioners.

---

## Directory Structure

### 🌥️ Cloud Platforms

| Path | Focus |
| --- | --- |
| `AWS/` | Service architecture, deployment patterns, security best practices, and provider-specific configurations |
| `Azure/` | Platform capabilities, networking deep-dives, encryption, load balancing, and Azure-native features |
| `Google Kubernetes Engine (GKE)/` | GKE cluster patterns, workload scaling strategies, and operational procedures |

**Use when**: Comparing cloud providers, learning provider-specific networking, or managing multi-cloud deployments

### 🐳 Kubernetes & Container Orchestration

| Path | Focus |
| --- | --- |
| `Kubernetes/` | Core manifests (Deployments, StatefulSets, DaemonSets, Services, NetworkPolicies), RBAC examples, and kubectl workflows |
| `Azure Kubernetes Service (AKS)/` | CNI options (Cilium, BYO, Kubenet, overlay), advanced networking, RDMA/InfiniBand, and GPU/ML workload integration |
| `Elastic Kubernetes Service (EKS)/` | Karpenter, IPv6-only clusters, private clusters, Local Zones, and advanced networking patterns |
| `Elastic Kubernetes Service-Anywhere/` | On-premises EKS deployments and hybrid cluster management |
| `Google Kubernetes Engine (GKE)/` | GKE cluster provisioning, networking configurations, and operational procedures |
| `Azure Kubernetes Service (AKS)/` | Comprehensive guides for deploying and managing AKS clusters |
| `OpenShift/` | Azure Red Hat OpenShift (ARO) and ROSA deployments with enterprise workflows |
| `Cilium/` | eBPF-based networking, network policies, BGP configurations, egress gateways, and observability |
| `Cluster API/` | Infrastructure-agnostic cluster provisioning templates and management workflows |

**Use when**: Deploying clusters, troubleshooting pod networking, implementing network policies, or managing multi-cluster setups

### 🔗 Networking & Infrastructure

| Path | Focus |
| --- | --- |
| `SDN/` | Software-defined networking concepts, diagrams, overlay networks, and underlay architecture |
| `Performance/` | Performance tuning experiments, SR-IOV, DPDK, poll-mode drivers, and benchmarking approaches |

**Use when**: Designing network topologies, optimizing performance, or implementing advanced networking patterns

### 🛠️ Developer Tools & Utilities

| Path | Focus |
| --- | --- |
| `Tools/` | Essential CLI tools (crictl, terraform, helm, docker), system utilities, git workflows, and SSH tips |
| `Mac/` | macOS-specific configurations, Homebrew tips, and development environment setup |
| `Windows/` | Windows development tools, WSL2 guidance, and platform-specific utilities |

**Use when**: Setting up development environments, configuring tools, or troubleshooting platform-specific issues

### 📚 Learning & Reference Materials

| Path | Focus |
| --- | --- |
| `Cheat-Sheets/` | Quick visual references for protocols, security models, Linux commands, and networking workflows |
| `Bookmarks/` | Curated collection of articles, videos, official documentation, and external resources |
| `Blog-Manifests/` | YAML, Dockerfile, and configuration files referenced in published blog articles |
| `My-Blogs/` | Links to published articles and technical writing across various platforms (Medium, Isovalent, Nutanix, etc.) |

**Use when**: Learning new concepts, quick reference lookups, or finding code examples

### 🏗️ Infrastructure-as-Code

| Path | Focus |
| --- | --- |
| `Azure-Utilities-Tools-created-with-Terraform/` | Reusable Terraform modules for Azure resources (Bastion hosts, virtual machines, networking) |
| `Blog-Manifests/` | Complete deployment examples and infrastructure blueprints from blog posts |

**Use when**: Automating infrastructure, managing resources with IaC, or deploying reusable modules

---

## Quick Start

### Installation & Setup

1. **Clone and explore**: 
```bash
git clone <repo-url> && cd tech-notes
```

2. **Navigate by interest**: Each directory contains a `README.md` with quick-start guides and scenario-specific workflows

3. **Search for specific content**: 
```bash
rg "ServiceAccount" --type md              # Find RBAC examples
rg "LoadBalancer" --type md               # Locate networking patterns
rg "terraform" --type md                   # Find IaC examples
```

### Common Starting Points

**New to Kubernetes?**
- Start with `Kubernetes/` for manifest fundamentals
- Then explore your cloud platform (AWS, Azure, GKE) for platform-specific patterns
- Refer to `Cheat-Sheets/` for quick lookups

**Deploying to a cloud platform?**
- AWS → Check `AWS/` and `Elastic Kubernetes Service (EKS)/`
- Azure → Check `Azure/` and `Azure Kubernetes Service (AKS)/`
- GCP → Check `Google Kubernetes Engine (GKE)/`

**Advanced networking?**
- Study `Cilium/` for eBPF-based networking
- Review `SDN/` for networking fundamentals and design patterns
- Check your cluster's specific directory (AKS, EKS, GKE) for advanced configurations

**Performance tuning?**
- See `Performance/` for SR-IOV, DPDK, and kernel tuning guides
- Review cluster-specific guides for optimized node configurations

**Looking for code examples?**
- Browse `Blog-Manifests/` for complete working examples
- Visit `My-Blogs/` for links to detailed articles explaining implementations

---

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

## Content Overview

### 👨‍💼 For Cloud Engineers
- Multi-cloud deployment patterns and cost optimization strategies
- Service interconnection, hybrid cloud, and disaster recovery architectures
- Identity & access management (IAM), encryption, and security controls
- Migration guides and best practices for legacy application modernization

### 👨‍💻 For Kubernetes Practitioners
- From basic Pod deployments to advanced StatefulSet patterns
- Multi-cluster networking and federation approaches
- CNI plugin deep-dives (Cilium, Flannel, Calico, Azure CNI)
- RBAC, network policies, and security hardening
- GitOps, observability, and operational runbooks

### 🔌 For Network Engineers
- BGP, OSPF, and SDN fundamentals with configuration examples
- Overlay vs. underlay network design decisions
- High-performance networking (DPDK, SR-IOV, kernel tuning)
- Service mesh networking and observability patterns

### 🚀 For DevOps & Platform Teams
- Infrastructure automation and Infrastructure-as-Code principles
- CI/CD pipeline design and GitOps workflows
- Monitoring, logging, and alerting architecture
- Disaster recovery and high availability strategies

---

## How to Use This Repository

### Browse by Scenario

| Your Need | Where to Look |
| --- | --- |
| Getting started with Kubernetes | `Kubernetes/` → Core manifests and basics |
| Deploying on AWS | `AWS/` → Platform guides, then `Elastic Kubernetes Service (EKS)/` → Cluster guides |
| Deploying on Azure | `Azure/` → Platform guides, then `Azure Kubernetes Service (AKS)/` → Cluster guides |
| Deploying on GCP | `Google Kubernetes Engine (GKE)/` → Cluster deployment and operations |
| Setting up advanced networking | `Cilium/` → eBPF networking, then cluster-specific guides for CNI configs |
| Performance optimization | `Performance/` → Tuning guides, then `SDN/` → Network architecture |
| Infrastructure automation | `Azure-Utilities-Tools-created-with-Terraform/` → Reusable modules |
| Finding code examples | `Blog-Manifests/` → Working YAML and configurations |
| Understanding concepts | `Cheat-Sheets/` → Quick references, `Bookmarks/` → External resources |
| Exploring published work | `My-Blogs/` → Links to articles and videos |

### Search Strategy

Use ripgrep or grep to jump directly to content:

```bash
# Find RBAC examples
rg "ServiceAccount" --type md

# Locate networking patterns
rg "LoadBalancer" --type md

# Find IaC examples
rg "terraform" --type md

# Search across multiple keywords
rg "pod.*network|network.*pod" --type md
```

### Adapting Content for Production

1. **Review the full guide** before copying manifests
2. **Customize for your environment**: Replace placeholders (CIDR blocks, regions, instance types, secrets)
3. **Test in non-production first**: Validate security policies, networking configurations, and resource limits
4. **Document your changes**: Keep notes on what was adapted and why
5. **Version control**: Maintain your customized manifests in a separate repository
6. **Refer to diagrams**: PNG/PDF visuals complement markdown guides for better understanding

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
