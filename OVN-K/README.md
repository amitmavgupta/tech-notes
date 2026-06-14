# OVN-K

Comprehensive observability guides, Grafana dashboards, and Prometheus ServiceMonitor configurations for OVN-Kubernetes (OVN-K) deployments. Includes dashboard setup instructions, metric queries, troubleshooting guides, and dashboard images for monitoring OVN-K control plane and data plane components.

---

## Directory Structure

### 📊 SDN-Dashboard

Observability and monitoring resources for OVN-K, including installation guides, dashboard configuration, and reference documentation:

**[install_sdn_dashboards.md](SDN-Dashboard/install_sdn_dashboards.md)**
- Prometheus + Grafana stack installation via Helm
- Port-forwarding for local UI access
- ServiceMonitor deployment for OVN-K components
- OVN-K dashboard installation from official Helm charts
- Support matrix: IC mode (current) vs. Centralized mode (1.0.0)

**[cni_requests.md](SDN-Dashboard/cni_requests.md)**
- CNI Add/Delete event monitoring
- Prometheus PromQL queries for CNI metrics
- Grafana dashboard navigation and visualization
- Reference dashboard screenshots (cni_request.png, cni_requests_percentile.png)

**[conntrack_entries.md](SDN-Dashboard/conntrack_entries.md)**
- Connection tracking (conntrack) metrics and utilization per node
- NAT health monitoring and diagnostics
- Graphical utilization dashboards
- Reference dashboard screenshots (conntrack_entries_per_node.png, nat_health_overview.png, node_nf_conntrack_entries.png)

**[troubleshooting.md](SDN-Dashboard/troubleshooting.md)**
- ServiceMonitor CRD verification and installation
- Prometheus operator troubleshooting
- Namespace selector configuration
- Service label matching and discovery issues

**[svc_monitor.yaml](SDN-Dashboard/svc_monitor.yaml)**
- ServiceMonitor resources for ovnkube-node, ovnkube-control-plane, and ovnkube-zone-controller
- Prometheus endpoint scrape configurations (interval, ports, metrics paths)
- Service definitions for metric discovery
- Label selectors for Prometheus scrape job matching

**[ovnk8s-nat-dashboard.json](SDN-Dashboard/ovnk8s-nat-dashboard.json)**
- Grafana dashboard JSON for OVN-K NAT monitoring (1.0.0 centralized mode)
- Pre-built panels for conntrack entries, NAT pool utilization, and health metrics
- Compatible with Grafana 7.x and later

---

## Quick Start

### 1. Install Prometheus + Grafana Stack

Deploy the monitoring stack using Helm:

```bash
# Install kube-prometheus-stack in monitoring namespace
kubectl create namespace monitoring
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack -n monitoring \
  --set prometheusOperator.tls.enabled=false \
  --set prometheusOperator.admissionWebhooks.enabled=false \
  --set prometheusOperator.admissionWebhooks.patch.enabled=false
```

### 2. Enable OVN-K Monitoring

Apply the ServiceMonitor for metric scraping:

```bash
# Apply ServiceMonitor and Service definitions
kubectl apply -f SDN-Dashboard/svc_monitor.yaml

# Verify ServiceMonitor installation
kubectl get servicemonitor -n ovn-kubernetes
kubectl get svc -n ovn-kubernetes | grep prometheus
```

### 3. Port-forward UI Access (optional)

```bash
# Access Grafana at http://localhost:3000
kubectl -n monitoring port-forward deployment/kube-prometheus-stack-grafana 3000:3000 --address 0.0.0.0

# Access Prometheus at http://localhost:9090
kubectl -n monitoring port-forward prometheus-kube-prometheus-stack-prometheus-0 9090:9090 --address 0.0.0.0
```

### 4. Install OVN-K SDN Dashboards

```bash
# Clone OVN-K repository for dashboard charts
git clone https://github.com/ovn-kubernetes/ovn-kubernetes.git
cd ovn-kubernetes/helm

# Install the dashboard Helm chart
helm install sdn-dashboard sdn-dashboard/

# Verify dashboard deployment
kubectl get helmrelease sdn-dashboard -n ovn-kubernetes
```

---

## Common Workflows

### Monitor CNI Performance

1. **Install monitoring stack** using step 1 above
2. **Enable OVN-K monitoring** using step 2 above
3. **Open Grafana** and navigate to the "OVN K8s / Node Agent" dashboard
4. **View CNI metrics**: cni_requests.md provides PromQL query examples
5. **Analyze visualizations**: Reference cni_request.png and cni_requests_percentile.png for expected dashboard layouts

### Monitor Connection Tracking (NAT)

1. **Navigate to OVN-K dashboards** in Grafana
2. **Select "OVN Host / Controller"** dashboard for conntrack metrics
3. **Review**: conntrack_entries_per_node.png, nat_health_overview.png, node_nf_conntrack_entries.png
4. **Check troubleshooting.md** if metrics are missing or sparse
5. **Query directly** in Prometheus for detailed analysis

### Troubleshoot Metric Collection

1. **Verify CRDs**: See troubleshooting.md for ServiceMonitor CRD checks
2. **Check namespace labels**: Ensure ovn-kubernetes namespace has `monitoring=true` label
3. **Verify service selectors** match ServiceMonitor selectors
4. **Confirm pods are running**: `kubectl get pods -n ovn-kubernetes`
5. **Inspect Prometheus targets**: http://localhost:9090/targets (port-forwarded)

### Customize Dashboards

1. **Download dashboard JSON** from Grafana (gear icon → Export)
2. **Edit panels** and PromQL queries as needed
3. **Import updated JSON** back into Grafana
4. **Commit changes** to ovnk8s-nat-dashboard.json for version control

---

## File Organization

```
OVN-K/
├── README.md (this file)
└── SDN-Dashboard/
    ├── install_sdn_dashboards.md (setup instructions)
    ├── cni_requests.md (CNI metrics and queries)
    ├── conntrack_entries.md (conntrack/NAT diagnostics)
    ├── troubleshooting.md (diagnostic and resolution steps)
    ├── svc_monitor.yaml (Prometheus scrape configuration)
    ├── ovnk8s-nat-dashboard.json (Grafana dashboard)
    ├── cni_request.png (CNI request dashboard screenshot)
    ├── cni_requests_percentile.png (CNI percentile dashboard)
    ├── conntrack_entries_per_node.png (per-node conntrack visualization)
    ├── nat_health_overview.png (NAT health summary)
    └── node_nf_conntrack_entries.png (detailed conntrack entries)
```

---

## Key Concepts

**OVN-K (OVN-Kubernetes)**: Open Virtual Network integration with Kubernetes for advanced SDN and overlay networking capabilities

**Prometheus**: Time-series metrics database and scraper for collecting application and infrastructure metrics

**Grafana**: Visualization and dashboarding platform for time-series data; displays Prometheus metrics

**ServiceMonitor**: Kubernetes CRD (Custom Resource Definition) that configures Prometheus to scrape metrics from Kubernetes services

**CNI (Container Network Interface)**: Kubernetes network plugin interface; OVN-K implements CNI for pod networking

**Conntrack**: Linux kernel connection tracking module for stateful firewall and NAT operations

**NAT (Network Address Translation)**: Address translation for pod egress traffic in OVN-K

**IC Mode (Interconnect)**: OVN-K current mode for multi-cluster and multi-region deployments

**Centralized Mode**: Legacy OVN-K mode supported until release 1.0.0; limited to single-zone deployments

---

## Usage Guidelines

1. **Dashboard Selection**: Choose dashboards based on monitoring target:
   - "OVN Host / Controller" for control plane and conntrack metrics
   - "OVN K8s / Cluster Manager" for cluster-wide orchestration
   - "OVN K8s / Node Agent" for per-node and CNI metrics

2. **Metric Queries**: All PromQL queries in cni_requests.md and troubleshooting documentation are copy-paste ready; adjust labels/filters for your environment

3. **Images and Screenshots**: Reference PNG files show expected dashboard layouts; use as visual guide if metrics panels differ

4. **ServiceMonitor Configuration**: svc_monitor.yaml defines scrape intervals (30s) and metric ports; adjust based on performance requirements

5. **Image References**: All markdown files use relative paths for image embeds (e.g., `![Description](image.png)`)

---

## Related Documentation

- **AWS**: Comprehensive guides for AWS EKS networking and operations
- **Azure Kubernetes Service (AKS)**: Similar observability guides for Azure AKS
- **OVN-Kubernetes Official**: https://ovn-kubernetes.io/observability/sdn-dashboard/
- **Prometheus Operator**: https://prometheus-operator.dev/

---

## Notes

- Prometheus scrape interval is set to 30 seconds by default; adjust in svc_monitor.yaml for faster metrics collection (higher resource usage)
- OVN-K default mode is IC; Centralized mode dashboards are available in ovnk8s-nat-dashboard.json for reference (OVN-K 1.0.0 only)
- Grafana datasource must point to the Prometheus instance in the monitoring namespace
- ServiceMonitor selectors must match the labels on OVN-K service ports (k8s-app: ovnkube-node, k8s-app: ovnkube-control-plane, etc.)
- Reference dashboard images are static examples; actual visualizations depend on workload and cluster metrics
- For multi-zone OVN-K deployments (IC mode), zone-controller metrics and dashboards provide zone-specific monitoring
