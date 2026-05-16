# Kubernetes Tools and Setup

## Kubernetes CLI Tools

### ksniff - Kubernetes Network Packet Sniffer

Install libpcap first:
```bash
echo 'export PATH="/opt/homebrew/opt/libpcap/bin:$PATH"' >> ~/.zshrc
```

For compilers:
```bash
export LDFLAGS="-L/opt/homebrew/opt/libpcap/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libpcap/include"
```

### kube_ps1 - Kubernetes Prompt

Enable in your shell:
```bash
source /path/to/kube-ps1.sh
PROMPT='$(kube_ps1)'$PROMPT
```

### kcli - Kubernetes CLI Tool

For more information and installation: https://github.com/karmab/kcli?tab=readme-ov-file

### kubectl_aliases

For kubectl_aliases to work, make sure to touch the license_header file:
```bash
touch license_header
```

## Minikube Setup

### Important Requirements

- Make sure Docker is installed and running
- Best to install Minikube from the official website
- Docker daemon must be running for Minikube to work properly

### Minikube Contexts

```bash
kubectl config get-contexts
CURRENT   NAME       CLUSTER    AUTHINFO   NAMESPACE
*         minikube   minikube   minikube   default
```

## Deployments

### Create and Expose Deployment

```bash
kubectl create deployment hello-minikube --image=kicbase/echo-server:1.0
kubectl expose deployment hello-minikube --type=NodePort --port=8080
```

### Check Services

```bash
kubectl get services hello-minikube
```

### Access Service

```bash
minikube service hello-minikube
```

## Load Balancer

### Create and Expose Load Balancer

```bash
kubectl create deployment balanced --image=kicbase/echo-server:1.0
kubectl expose deployment balanced --type=LoadBalancer --port=8080
```

### Start Tunnel for Routable IP

```bash
minikube tunnel
```

### Get Routable IP

```bash
kubectl get services balanced
```

## Ingress

### Enable Ingress Add-on

```bash
minikube addons enable ingress
```

### Check Ingress Pods

```bash
kubectl get pods -n ingress-nginx
```

Example output:
```
NAME                                        READY   STATUS      RESTARTS   AGE
ingress-nginx-admission-create-nz4zl        0/1     Completed   0          38m
ingress-nginx-admission-patch-md6pl         0/1     Completed   1          38m
ingress-nginx-controller-5959f988fd-8zpxt   1/1     Running     0          38m
```

## Deployment Management

### Delete Deployment

```bash
kubectl delete deployment <x>
```

### Scale Deployment

```bash
kubectl scale deployment shop --replicas=0 -n service
```

### Rollout Restart Deployment

```bash
kubectl rollout restart deployment <deployment_name> -n <namespace>
```

### Delete Replica Set

```bash
kubectl delete replicaset <name> -n <namespace>
```

### Replace Pod Force

```bash
kubectl get pod <pod_name> -n <namespace> -o yaml | kubectl replace --force -f -
```

## Helm

### List Helm Releases

```bash
helm list -A
```
