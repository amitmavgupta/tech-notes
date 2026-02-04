# How to install prometheus in your kubernetes cluster?

- Add the helm repo 

```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```

- Upgrade the cluster

```
helm upgrade --install -n monitoring prometheus prometheus-community/kube-prometheus-stack
Release "prometheus" has been upgraded. Happy Helming!
NAME: prometheus
LAST DEPLOYED: Wed Jun  5 20:32:47 2024
NAMESPACE: monitoring
STATUS: deployed
REVISION: 2
NOTES:
kube-prometheus-stack has been installed. Check its status by running:
  kubectl --namespace monitoring get pods -l "release=prometheus"

Visit https://github.com/prometheus-operator/kube-prometheus for instructions on how to create & configure Alertmanager and Prometheus instances using the Operator.
```

- Run port-monitor to open its UI

```
kubectl -n monitoring port-forward service/prometheus-grafana --address 0.0.0.0 --address :: 80:80
```
