# Tetragon Grafana Dashboard

This document describes the tetragon-dashboard.json Grafana dashboard file and how to use, import, and customize it.

- Dashboard JSON file: [tetragon-dashboard.json](/Users/amit.gupta1/Downloads/tech-notes/tech-notes.worktrees/tetragon-dashboard-md-docs/Kubernetes/Observability/Tetragon-Grafana-Dashboard/tetragon-dashboard.json)
- Location: Kubernetes/Observability/Tetragon-Grafana-Dashboard/

## Purpose

The tetragon-dashboard.json file is a Grafana dashboard definition that visualizes data collected for Tetragon (observability and security telemetry). It provides pre-built panels and variables to help monitor Tetragon-related metrics, traces, and logs from your Kubernetes cluster.

## Quick import (Grafana UI)

1. Open Grafana (log in with an admin account).
2. From the left menu, choose + Create → Import.
3. Either upload the tetragon-dashboard.json file or paste its JSON content.
4. Choose the appropriate data source(s) when prompted (Prometheus, Loki, Tempo, or a mixed datasource depending on panels).
5. Save the dashboard to make it available to users.

## Import via provisioning (recommended for GitOps)

To provision the dashboard automatically (recommended for reproducible deployments), add a dashboard provisioning YAML to your Grafana provisioning directory. Example snippet (provisioning/dashboards/tetragon-dashboard.yaml):

```yaml
apiVersion: 1
providers:
  - name: 'tetragon'
    orgId: 1
    folder: 'Tetragon'
    type: file
    options:
      path: /var/lib/grafana/dashboards/tetragon
```

Place tetragon-dashboard.json in the path referenced by the provider (e.g. /var/lib/grafana/dashboards/tetragon) on the Grafana server/container.

## Datasources

Panels in the dashboard commonly depend on these datasources (verify JSON to confirm exact datasource names):

- Prometheus — metrics for Tetragon (CPU, memory, custom metrics, eBPF metrics)
- Loki — logs for events and troubleshooting (if log panels are included)
- Tempo or Jaeger — traces (if tracing panels are included)

When importing, map the dashboard's expected datasource names to your Grafana datasources.

## Panels and Variables (overview)

While the exact panels come from the JSON, typical dashboards for Tetragon include:

- Cluster summary (node/pod counts, health indicators)
- Tetragon-specific metrics (events/sec, dropped events, rule matches)
- eBPF telemetry (latencies, dropped samples)
- Per-namespace / per-pod heatmaps and time series
- Log search panels (Loki) with templated queries
- Links to traces for detailed request analysis

Common template variables:

- Cluster or context
- Namespace
- Pod or workload
- Time range
- Metric/label selectors

Variables allow users to filter and focus the dashboard quickly.

## Customization

- Rename datasources inside the JSON to match your Grafana instance (search/replace "prometheus" or other datasource names).
- Adjust panel queries to match your metric labels and Prometheus job names.
- Add or remove panels depending on what Tetragon components are deployed in your environment.
- Tune panel visualization (unit, thresholds, legends) for your team's needs.

## Recommended Grafana version and plugins

- Supported Grafana: 12.x and later (verify in the JSON for any panel features requiring newer Grafana versions).
- Plugins: If panels use plugin panels (e.g., statusmap, diagram), ensure those plugins are installed on the Grafana instance.

## Troubleshooting

- Blank panels after import: verify datasource mapping and that Prometheus/Loki contain the expected metrics/logs.
- Missing variables: check that the templated variable queries return results in Explore, and that required label names are present in the Prometheus metric sets.
- Provisioning not loading: confirm provisioning YAML is placed in Grafana's provisioning folder and that file paths referenced point to the JSON file location inside the Grafana container.

## Tips for maintainers

- Keep the JSON under version control in this repo so dashboard changes are auditable and deployable by CI/CD.
- Split very large dashboards into smaller focused dashboards if load or complexity becomes an issue.
- Document any datasource name expectations in your cluster's README or Grafana provisioning docs.
