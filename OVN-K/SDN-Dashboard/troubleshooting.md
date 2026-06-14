### check that service monitor CRD's are installed.

kubectl get crd servicemonitors.monitoring.coreos.com

### If they are not found them install them

helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \ --namespace monitoring --create-namespace

Or apply the CRD’s standalone

kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/main/bundle.yaml

Check

kubectl get prometheus -n monitoring -o yaml | grep -A5 serviceMonitorNamespaceSelector

If not then adjust label to match your selector

kubectl label namespace ovn-kubernetes monitoring=true
