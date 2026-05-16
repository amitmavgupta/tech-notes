# Kubernetes Commands Reference

## Display Pods with Nodes

```bash
kubectl get pod -o=custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName -A
```

## List Containers in a Pod

```bash
kubectl get pods <pod-name> -o jsonpath='{.spec.containers[*].name}' -n <namespace>
```

## List All Containers in Cluster

```bash
kubectl get po -o jsonpath='{range .items[*]}{"pod: "}{.metadata.name}{"\n"}{range .spec.containers[*]}{"\tname: "}{.name}{"\n\timage: "}{.image}{"\n"}{end}' -A
```

```bash
kubectl get pods -o=custom-columns=PodName:.metadata.name,Containers:.spec.containers[*].name,Image:.spec.containers[*].image -A
```

## Count Pods

```bash
kubectl get pods -A | wc -l
```

## Get Nodes with Labels

```bash
kubectl get nodes -o wide --show-labels=true
```

## List Instances with Instance Type

```bash
kubectl get nodes -o json|jq -Cjr '.items[] | .metadata.name," ",.metadata.labels."beta.kubernetes.io/instance-type"," ",.metadata.labels."beta.kubernetes.io/arch", "\n"'|sort -k3 -r
```

Example output:
```
ip-X-X-X-X.ap-northeast-2.compute.internal m5d.metal amd64
ip-X-X-X-X.ap-northeast-2.compute.internal m5.xlarge amd64
ip-X-X-X-X.ap-northeast-2.compute.internal m5.xlarge amd64
ip-X-X-X-X.ap-northeast-2.compute.internal m5d.metal amd64
```

## Find Node Architecture

```bash
kubectl get no -L kubernetes.io/arch
```

Example output:
```
NAME                                                 STATUS   ROLES    AGE   VERSION                ARCH
ip-X-X-X-X.ap-northeast-2.compute.internal          Ready    <none>   57m   v1.29.12-eks-aeac579   arm64
ip-X-X-X-X.ap-northeast-2.compute.internal          Ready    <none>   57m   v1.29.12-eks-aeac579   arm64
```

## Pod Operations

### Create Pod

```bash
kubectl run -i --tty test-pod --image=quay.io/isovalent-dev/ktls-curl:latest --restart=Never --rm
```

### Delete Pod Immediately

```bash
kubectl delete pod <pod-name> --now
```

### Exec into Pod

```bash
kubectl exec -it <demo-pod> -- /bin/sh
```

### Get Pod Logs

```bash
kubectl logs <pod-name>
```

### Get Previous Pod Logs (Before Last Restart)

```bash
kubectl logs <pod-name> --previous
```

### Show Logs from Pods with Specific Labels

```bash
kubectl logs -l app=xyz
```

### Pod Logs with Timestamps

```bash
kubectl -n kube-system logs --timestamps <pod-name>
kubectl -n kube-system logs --timestamps -p <pod-name>
```

## Copy Files

### Copy from Pod to Local

```bash
kubectl cp <namespace>/<pod>:<file_path> <local_file_path>
```

Example:
```bash
kubectl cp default/rebel-base-5bf7459776-rpqsq:tmp/test.pcap /home/test/cloud/google/test.pcap
```

## Container Information

### Get Container IDs

```bash
kubectl get pods --all-namespaces --output jsonpath='{.items[*].status.containerStatuses[*].containerID}' | sed 's/ /\n/g'
```

## Contexts

### Get Current Context

```bash
kubectl config get-contexts
```

### Switch Context

```bash
kubectl config use-context kind-c1
```

### Get Cluster Info

```bash
kubectl cluster-info --context kind-c1
```

### Set Current Namespace

```bash
kubectl config set-context --current --namespace=default
```

### Delete Context

```bash
kubectl config delete-context gke_cilium-demo_us-west2-a_test-test-10357
```

## Events and Endpoints

### Get Events Sorted by Timestamp

```bash
kubectl get events --sort-by=".lastTimestamp"
```

### List Endpoints Across All Namespaces

```bash
kubectl get ep -A
```

## Annotations

### Add Annotation

```bash
kubectl annotate <resource-type>/<resource-name> foo=bar
```

### Remove Annotation

```bash
kubectl annotate <resource-type>/<resource-name> foo-
```

## Cluster Information

### Cluster Dump

```bash
kubectl cluster-info dump
```

### Get Pods and Services

```bash
kubectl get pods,svc
```

## Memory Usage

### Get Pods Sorted by Memory Usage

```bash
kubectl top pods -A --sort-by='memory'
```
