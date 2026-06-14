# OVN-K

OVN-Kubernetes (OVN-K) observability and SDN dashboard guides, monitoring manifests, and reference images for OVN-K dashboards and ServiceMonitors.

---

## Directory structure

OVN-K/
├── README.md (this file)
├── SDN-Dashboard/ (Grafana dashboards, ServiceMonitor, and images)
│   ├── install_sdn_dashboards.md
│   ├── cni_requests.md
│   ├── conntrack_entries.md
│   ├── troubleshooting.md
│   ├── svc_monitor.yaml
│   ├── ovnk8s-nat-dashboard.json
│   └── *.png (dashboard images)

---

## Quick start

1. Follow SDN-Dashboard/install_sdn_dashboards.md to install dashboards and ServiceMonitors.
2. Ensure Prometheus and Grafana are available in the monitoring namespace.
3. Apply `svc_monitor.yaml` to enable monitoring for OVN-K components.

---

## Notes

- Image files are referenced relatively (e.g., `![Alt text](cni_request.png)`).
- If additional images are added, reference them in the markdown files under SDN-Dashboard/.
- This README mirrors the structure used for AWS for consistency across the repository.
