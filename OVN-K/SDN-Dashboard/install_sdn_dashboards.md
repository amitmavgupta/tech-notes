Install Prometheus-Grafana Helm Chart

```bash
kubectl create namespace monitoring
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack -n monitoring \
  --set prometheusOperator.tls.enabled=false \
  --set prometheusOperator.admissionWebhooks.enabled=false \
  --set prometheusOperator.admissionWebhooks.patch.enabled=false
```

## Port Forwarding (optional)

```bash
# Grafana
kubectl -n monitoring port-forward deployment/kube-prometheus-stack-grafana 3000:3000 --address 0.0.0.0
# Prometheus
kubectl -n monitoring port-forward prometheus-kube-prometheus-stack-prometheus-0 9090:9090 --address 0.0.0.0
```

## Install ServiceMonitor (reference svc_monitor.yaml)

```bash
kubectl apply -f svc_monitor.yaml
```

Look for 1.0.0 or releases for OVN-K for your respective OVN-Release that you want the dashboards to be installed for

```bash
git clone https://github.com/ovn-kubernetes/ovn-kubernetes.git
cd ovn-kubernetes/helm
helm install sdn-dashboard sdn-dashboard/
```

Note: By default OVN-K has moved to IC mode. For Centralized mode, the support was available till release 1.0.0. This will provide you with three handy dashboards for 

- OVN Host/ Controller
- OVN K8s/ Cluster Manager
- OVN K8s/ Node Agent

Reference: 
[SDN-Dashboard](https://ovn-kubernetes.io/observability/sdn-dashboard/#sdn-dashboards)
[Metrics](https://ovn-kubernetes.io/observability/metrics/)