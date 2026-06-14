# Troubleshooting Prometheus ServiceMonitors

Verify ServiceMonitor CRDs and discovery so Prometheus can scrape OVN-K metrics.

## Check CRD

```bash
kubectl get crd servicemonitors.monitoring.coreos.com
```

## Install Prometheus Operator (if CRDs missing)

```bash
# Install or upgrade the kube-prometheus-stack via Helm
helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace

# Or apply the operator bundle directly
kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/main/bundle.yaml
```

## Verify namespace selector

```bash
kubectl get prometheus -n monitoring -o yaml | grep -A5 serviceMonitorNamespaceSelector
```

If your Prometheus instance uses a namespace selector, ensure the OVN namespace is labelled:

```bash
kubectl label namespace ovn-kubernetes monitoring=true
```

If metrics are still missing, check Service and Pod labels for the components (ovnkube-node, ovnkube-control-plane, ovnkube-zone-controller) to ensure ServiceMonitor selectors match.