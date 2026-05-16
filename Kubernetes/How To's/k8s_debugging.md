# Kubernetes Debugging and Troubleshooting

## Daemon Sets

### Get Daemon Sets

```bash
kubectl get daemonsets
```

Example output:
```
NAME         DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
cilium       1         1         1       1            1           kubernetes.io/os=linux   25h
kube-proxy   1         1         1       1            1           kubernetes.io/os=linux   26h
```

### Describe Daemon Set

```bash
kubectl describe daemonsets/cilium
```

Example output:
```
Name:           cilium
Selector:       k8s-app=cilium
Node-Selector:  kubernetes.io/os=linux
Labels:         k8s-app=cilium
Annotations:    deprecated.daemonset.template.generation: 1
Desired Number of Nodes Scheduled: 1
Current Number of Nodes Scheduled: 1
Number of Nodes Scheduled with Up-to-date Pods: 1
Number of Nodes Scheduled with Available Pods: 1
Number of Nodes Misscheduled: 0
Pods Status:  1 Running / 0 Waiting / 0 Succeeded / 0 Failed
```

### Delete Daemon Set

```bash
kubectl delete daemonsets tetragon
```

### Get Daemon Set Logs

```bash
kubectl logs -f -c tetragon tetragon-crf8q
```

## Pod Debugging

### Debug Pod

```bash
kubectl debug myapp -it --image=ubuntu --share-processes --copy-to=myapp-debug
```

### Debug with Container Processes

```bash
kubectl debug -it -c debugger --target=my-nginx-754c4d44b4-lvkng --image=busybox myapp --share-processes
```

### Debug with Network Admin Profile

```bash
kubectl debug -it --profile=netadmin --image=<image> <node or pod>
```

Then use iptables:
```bash
iptables -nvL
```

### Describe Pod

```bash
kubectl describe pod -n kube-system <pod-name>
```

### Get Pod Deployment

```bash
kubectl get deployment <name> -o yaml
```

## Network Debugging

### Check Network Connectivity

Using TCP:
```bash
cat < /dev/tcp/host/port
```

Using UDP:
```bash
cat < /dev/udp/host/port
```

### Test Service Connectivity

```bash
kubectl exec -it svc/random-service -- bash
$ echo < /dev/tcp/other-service.namespace.svc.cluster.local/7777 && echo "open" || echo "closed"
```

## CoreDNS Issues

### Check DNS Service

```bash
kubectl get svc --namespace=kube-system
```

### Check DNS Logs

```bash
kubectl logs --namespace=kube-system -l k8s-app=kube-dns
```

### Check DNS Endpoints

```bash
kubectl get endpoints kube-dns --namespace=kube-system
```

### Check DNS Pod Configuration

```bash
kubectl -n kube-system get pod -l k8s-app=kube-dns -o yaml | grep -i hostnetwork
```

### Edit CoreDNS Config

```bash
kubectl edit cm coredns -n kube-system
```

### Get DNS Logs

```bash
kubectl logs —namespace=kube-system -l k8s-app=kube-dns
```

## Network Policies

### Describe Network Policy

```bash
kubectl describe cnp rule1
```

### Delete Network Policy

```bash
kubectl delete networkpolicy default-deny-ingress
```

### List Network Policies

```bash
kubectl get networkpolicies.networking.k8s.io -A
```

## Pod Lifecycle

### Check Pod Lifecycle Hooks

```bash
kubectl ice lifecycle -A
```

Example output:
```
NAMESPACE    PODNAME       CONTAINER     LIFECYCLE  HANDLER  ACTION
kube-system  cilium-c7z8c  cilium-agent  preStop    Exec     /cni-uninstall.sh
```

## Namespaces

### Get Namespaces

```bash
kubectl get ns
```

### Describe Pod in Namespace

```bash
kubectl describe pod -n kube-system cilium-wq6tk
```
