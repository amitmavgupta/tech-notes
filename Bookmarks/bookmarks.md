# Bookmarks

A living collection of carefully curated reference materials, documentation, best practices, and technical deep-dives across cloud platforms, Kubernetes distributions, networking, and infrastructure tools.

---

## Quick Navigation

| Category | Topics | Count |
| --- | --- | --- |
| **Kubernetes** | EKS, AKS, GKE, KubeVirt, kind, OpenShift | 15 |
| **Azure** | AKS, networking, virtual machines, managed services | 9 |
| **AWS** | EC2, EKS, CloudFormation, networking | 8 |
| **Cloud Networking** | Cilium, SDN, network policies, egress management | 7 |
| **Tools & CLI** | kubectl, kubelogin, taskcat, helm utilities | 5 |
| **Infrastructure & Virtualization** | nested virtualization, KubeVirt, WSL2 | 6 |
| **Learning Resources & Blogs** | deep-dives, best practices, technical articles | 12 |
| **Security & Observability** | Pod security, Linux hardening, monitoring | 6 |

---

## 📚 Kubernetes

### EKS (Elastic Kubernetes Service)
- [EKS best practices guide](https://docs.aws.amazon.com/eks/latest/best-practices/introduction.html?advocacy_source=everyonesocial&trk=global_employee_advocacy&sc_channel=sm&es_id=cce017dde6)
- [Cluster Insights](https://docs.aws.amazon.com/eks/latest/userguide/cluster-insights.html)
- [AWS Load Balancer Controller](https://docs.aws.amazon.com/eks/latest/userguide/lbc-helm.html)
- [Troubleshooting EKS Networking](https://repost.aws/articles/ARMvpWa7AYScyBBPRr6xkvXw)

### EKS-Anywhere
- [EKS-A Curated Packages Installation](https://anywhere.eks.amazonaws.com/docs/packages/prereq/)
- [EKS-A Cluster Troubleshooting](https://anywhere.eks.amazonaws.com/docs/troubleshooting/troubleshooting/)
- [Registering non-EKS clusters using eksctl](https://eksctl.io/usage/eks-connector/)

### AKS (Azure Kubernetes Service)
- [AKS Troubleshooting](https://learn.microsoft.com/en-in/troubleshoot/azure/azure-kubernetes/welcome-azure-kubernetes)
- [Image Cleaner in AKS](https://learn.microsoft.com/en-us/azure/aks/image-cleaner)
- [Vertical Pod Autoscaler in AKS](https://learn.microsoft.com/en-us/azure/aks/use-vertical-pod-autoscaler)
- [Kubernetes Event-driven Autoscaling (KEDA) in AKS](https://learn.microsoft.com/en-us/azure/aks/keda-deploy-add-on-cli)
- [AKS Automatic (using Azure CNI powered by Cilium)](https://learn.microsoft.com/en-us/azure/aks/automatic/quick-automatic-managed-network?pivots=azure-cli)
- [AKS Communication Manager](https://learn.microsoft.com/en-us/azure/aks/aks-communication-manager) - Timely alerts on upgrade events and outcomes using Azure Resource Notifications and Resource Graph
- [AKS Marketplace Extension Troubleshooting](https://learn.microsoft.com/en-us/troubleshoot/azure/azure-kubernetes/extensions/cluster-extension-deployment-errors)

### KubeVirt & Virtualization
- [Download virtctl](https://kubevirt.io/user-guide/user_workloads/virtctl_client_tool/)
- [OpenShift Virt Lab](https://www.stb.id.au/blog/openshift-virt-lab)

### kind (Kubernetes in Docker)
- [Pod Errors (Too Many Files) in a Kind Cluster](https://kind.sigs.k8s.io/docs/user/known-issues/#pod-errors-due-to-too-many-open-files) - May be caused by running out of inotify resources

### OpenShift
- [Installing Cilium with HyperShift (OpenShift)](https://hypershift-docs.netlify.app/how-to/agent/other-sdn-providers/#cilium)

### General Kubernetes
- [Pod Info](https://docs.google.com/document/d/1MlOEoNr8j0LlD2w5RMb6E8R55e93aWpzWLgFAIctn8o/edit?usp=sharing)
- [Karpenter Compatibility Matrix](https://karpenter.sh/docs/upgrading/compatibility/)

---

## ☁️ Azure

### Azure-Specific Services & Tools
- [AZQR Tool](https://github.com/Azure/azqr) - Azure Quick Review: CLI tool for analyzing Azure resources and ensuring compliance with best practices
- [Find Ubuntu Image on Azure](https://documentation.ubuntu.com/azure/azure-how-to/instances/find-ubuntu-images/)
- [Enable Nested Virtualization on a VM in Azure](https://learn.microsoft.com/en-us/answers/questions/1405242/how-to-enable-nested-virtualization-on-d4s-v3) - Nested Virt on d4sv3
- [Generated Bicep Docs](https://github.com/christosgalano/bicep-docs)
- [Learning Azure](https://github.com/shiftavenue/awesome-azure-learning)

### Azure Managed Applications
- [Test your Portal Interface for Azure Managed Applications](https://learn.microsoft.com/en-us/azure/azure-resource-manager/managed-applications/test-createuidefinition)
- [Create UI Definition Sandbox](https://portal.azure.com/#view/Microsoft_Azure_CreateUIDef/SandboxBlade)

### Azure Authentication
- [Azure Kubelogin](https://azure.github.io/kubelogin/index.html)

---

## 🔴 AWS

### EC2 & Networking
- [Maximum IP Addresses per Network Interface](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AvailableIpPerENI.html)
- [EC2 Networking Deep Dive](https://www.youtube.com/watch?v=_hiNXKQZc0M)

### CloudFormation & Infrastructure
- [Taskcat](https://github.com/aws-ia/taskcat) - Tool for testing AWS CloudFormation templates

### AWS Resources & Learning
- [AWS Solutions Hub](https://github.com/kirby-rocket/AWS-Solutions-Hub)

---

## 🌐 Cloud Networking

### Cilium & eBPF
- [Cilium on WSL2](https://github.com/cilium/cilium/issues/29302)
- [Network Policy in Cilium - Philip Schmid](https://github.com/PhilipSchmid/cilium-netpol-demo/tree/main)
- [Security and Observability with Cilium on 5G](https://luislogs.com/posts/security-and-observability-with-cilium-on-my-5g-network/)
- [Kubernetes-aware Traffic Monitoring (egressd)](https://github.com/castai/egressd)

### Networking Deep Dives
- [Google VPC and Peering Deep Dive](https://medium.com/google-cloud/google-networking-deep-dive-whats-behind-the-scenes-147a4b7eabe7)
- [Linux Routing Fundamentals](https://blog.sdn.clinic/2025/01/linux-routing-fundamentals/)

### Networking Tools
- [Visual Subnet Calculator](https://visualsubnetcalc.com/)

---

## 🛠️ Tools & CLI

### Kubernetes Client Tools
- [Kubernetes OIDC Authentication (Kubelogin)](https://github.com/int128/kubelogin)

### Development & Testing
- [Asynchronous HTTP Client/Server (AIOHTTP)](https://docs.aiohttp.org/en/stable/index.html)

---

## 🖥️ Infrastructure & Virtualization

### VM & Container Images
- [Cirros Images](https://download.cirros-cloud.net/0.6.3/) - Lightweight Linux for testing

### Virtualization
- [Enable Nested Virtualization on Azure VMs](https://learn.microsoft.com/en-us/answers/questions/1405242/how-to-enable-nested-virtualization-on-d4s-v3)

---

## 📖 Learning Resources & Best Practices

### Deep-Dive Articles & Documentation
- [EKS Best Practices Guide](https://docs.aws.amazon.com/eks/latest/best-practices/introduction.html?advocacy_source=everyonesocial&trk=global_employee_advocacy&sc_channel=sm&es_id=cce017dde6)
- [Troubleshooting EKS Networking](https://repost.aws/articles/ARMvpWa7AYScyBBPRr6xkvXw)
- [Google VPC and Peering Deep Dive](https://medium.com/google-cloud/google-networking-deep-dive-whats-behind-the-scenes-147a4b7eabe7)
- [EC2 Networking Under the Hood](https://www.youtube.com/watch?v=_hiNXKQZc0M)
- [Linux Routing Fundamentals](https://blog.sdn.clinic/2025/01/linux-routing-fundamentals/)

---

## 🔒 Security & Observability

### Pod Security & Container Hardening
- [Linux Privilege Escalation Script (LinPEAS)](https://github.com/peass-ng/PEASS-ng/blob/master/linPEAS/README.md)

### Observability & Monitoring
- [Security and Observability with Cilium on 5G](https://luislogs.com/posts/security-and-observability-with-cilium-on-my-5g-network/)

---

## How to Use This Collection

1. **Quick lookup**: Use Ctrl+F to search by keyword or technology name
2. **Browse by platform**: Navigate to your cloud provider section (AWS, Azure, GCP)
3. **Deep-dive**: Follow links to official documentation or technical articles
4. **Combine with repo**: Reference alongside the main tech-notes knowledge base for hands-on guides

---

## Related Resources

- **Tech-Notes Knowledge Base**: Parent directory with hands-on guides and tutorials
- **Blog-Manifests**: YAML and configuration files from published articles
- **Cheat-Sheets**: Quick reference materials and command summaries

---

**Last Updated**: 2026-05-18
