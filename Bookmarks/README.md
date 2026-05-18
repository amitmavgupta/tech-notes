# Bookmarks

A living collection of carefully curated reference materials, documentation, best practices, and technical deep-dives across cloud platforms, Kubernetes distributions, networking, and infrastructure tools.

---

## Overview

The `bookmarks.md` file contains a comprehensive, organized collection of high-quality external resources. These links complement the hands-on guides and manifests in the main tech-notes repository, providing quick access to official documentation, deep-dive articles, best practices, and community resources.

**Purpose:**
- Maintain a single, curated source of trusted external references
- Organize resources by technology and use case for quick discovery
- Support learning across multiple cloud platforms and Kubernetes distributions
- Provide links to troubleshooting guides, tool documentation, and architectural patterns

---

## Quick Navigation

| Category | Focus Areas | Entry Count |
| --- | --- | --- |
| **📚 Kubernetes** | EKS, AKS, GKE, KubeVirt, kind, OpenShift, autoscaling, virtualization | 15 |
| **☁️ Azure** | AKS, Bicep, managed applications, authentication, tools | 9 |
| **🔴 AWS** | EC2, EKS, CloudFormation, networking, testing | 8 |
| **🌐 Cloud Networking** | Cilium, eBPF, network policies, routing, SDN | 7 |
| **🛠️ Tools & CLI** | kubectl, kubelogin, AIOHTTP, CI/CD tooling | 5 |
| **🖥️ Infrastructure & Virtualization** | nested virtualization, KubeVirt, container images, WSL2 | 6 |
| **📖 Learning Resources** | best practices, deep-dives, architectural articles | 12 |
| **🔒 Security & Observability** | pod security, hardening, compliance monitoring | 6 |

---

## Content Organization

### `bookmarks.md`
The main reference file organized by technology category and subcategory:
- **Clear hierarchical structure** with main categories and topic subsections
- **Descriptive link text** with optional explanatory notes for context
- **Grouped by platform and use case** for efficient browsing and searching
- **Anchor links** support quick navigation via Ctrl+F search

### Category Breakdown

**Kubernetes**: Covers all major distributions and patterns
- EKS-specific resources (best practices, networking, clustering)
- AKS guides (autoscaling, add-ons, troubleshooting)
- KubeVirt for virtualized workloads
- kind for local development
- OpenShift CNI integration

**Azure**: Azure cloud and managed services
- AKS features and troubleshooting
- Azure authentication and authorization
- Bicep infrastructure-as-code
- VM management and nested virtualization

**AWS**: AWS cloud services
- EC2 networking and deep-dives
- EKS best practices
- CloudFormation testing
- Solutions and reference architectures

**Cloud Networking**: Multi-cloud networking topics
- Cilium implementation and network policies
- eBPF fundamentals
- Routing and traffic management
- Kubernetes-aware traffic monitoring

**Tools & CLI**: Developer and operations tools
- Kubernetes client authentication (kubelogin)
- Development libraries and testing frameworks
- Infrastructure and container tooling

**Infrastructure & Virtualization**: Compute and VM management
- Nested virtualization on cloud providers
- Container images and registries
- WSL2 integration for hybrid workflows

**Learning Resources**: Educational and reference materials
- Official best practices guides
- Technical deep-dives and blog posts
- Architectural patterns and case studies

**Security & Observability**: Security and monitoring
- Pod hardening and container security
- Linux privilege escalation testing
- Observability and compliance monitoring

---

## How to Use This Collection

### 1. **Quick Lookup**
- Use **Ctrl+F** to search by technology name (e.g., "Cilium", "EKS", "AKS")
- Search by keywords (e.g., "networking", "troubleshooting", "autoscaling")

### 2. **Browse by Platform**
- Start with your primary cloud provider section (AWS, Azure, GCP)
- Explore platform-specific guides and best practices

### 3. **Find by Use Case**
- **Learning a new technology?** Start in the relevant section's documentation links
- **Troubleshooting?** Look in category subsections for specific error messages or issues
- **Design review?** Check Deep-Dive articles and best practices

### 4. **Combine with Main Repo**
- Use bookmarks for **external reference documentation**
- Reference alongside `/AWS`, `/Azure`, `/Kubernetes` directories for **hands-on implementations**
- Mix with **Blog-Manifests** for **real-world examples**

---

## Adding New Bookmarks

When adding new references to `bookmarks.md`:

1. **Find the most specific category** - Prefer narrower categories over generic ones
2. **Use descriptive link text** - Make it searchable and self-documenting
3. **Add context notes** - Include a brief explanation if the purpose isn't obvious
4. **Maintain alphabetical order** within each subcategory when possible
5. **Update the Quick Navigation table** if adding a new major category

Format example:
```markdown
### New Topic Area
- [Descriptive Title](https://example.com) - Brief context or explanation (optional)
```

---

## Related Resources

- **Tech-Notes Knowledge Base**: Parent directory with hands-on guides, tutorials, and manifests
- **Blog-Manifests**: YAML and configuration files extracted from published articles
- **Cheat-Sheets**: Quick reference materials, command summaries, and common workflows
- **My-Blogs**: Complete index of published articles and videos across platforms

---

## Tips for Effective Learning

1. **Start with best practices guides** - Official documentation provides the foundation
2. **Read platform-specific deep-dives** - Understand architecture and design patterns
3. **Review troubleshooting resources** - Learn from common issues and their solutions
4. **Explore tool documentation** - Detailed guides for CLI utilities and frameworks
5. **Combine multiple sources** - Cross-reference articles and documentation for complete understanding

---

## Last Updated

**2026-05-18** — Bookmarks reorganized by topic with quick navigation table, improved README with usage guidance
