# Azure Kubernetes Service Commands

## Get Pod and Service CIDR

### Get Service CIDR

```bash
az aks show -n tmetest -g tmetest --subscription XXXXXXXXXXXX | grep serviceCidr
```

Output:
```
"serviceCidr": "10.0.0.0/16",
"serviceCidrs": [
```

### Get Pod CIDR

```bash
az aks show -n tmetest -g tmetest --subscription XXXXXXXXXXXX | grep podCidr
```

Output:
```
"podCidr": "10.244.0.0/16",
"podCidrs": [
```

## Update kubeconfig

```bash
aws eks update-kubeconfig --region region-code --name my-cluster
```

## Check Nodes Across Regions

```bash
kubectl get nodes -o custom-columns=NAME:'{.metadata.name}',REGION:'{.metadata.labels.topology\.kubernetes\.io/region}',ZONE:'{metadata.labels.topology\.kubernetes\.io/zone}'
```
