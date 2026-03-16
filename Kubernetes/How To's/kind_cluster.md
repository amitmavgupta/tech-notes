# Creating a Kind cluster

- Install golang-go

```
apt  install golang-go -y

curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.31.0/kind-linux-amd64

chmod +x ./kind

mv ./kind /usr/local/bin
```

- Validate Kind version
```
kind version
kind v0.31.0 go1.25.5 linux/amd64
```

- Create a sample kind-config.yaml
```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
- role: worker
networking:
  disableDefaultCNI: true
```

- Install Docker- Run the following command to uninstall all conflicting packages:
```
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
```

- Add Docker's official GPG key:
```
sudo apt-get update

sudo apt-get install ca-certificates curl

sudo install -m 0755 -d /etc/apt/keyrings

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

sudo chmod a+r /etc/apt/keyrings/docker.asc
```

- Add the repository to Apt sources:
```
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
```

- To install the latest version, run:
```
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

- Create kind cluster
```
kind create cluster --config=kind-config.yaml
```

- Check the status of the kind cluster
```
kubectl cluster-info --context kind-kind
Kubernetes control plane is running at https://127.0.0.1:41547
CoreDNS is running at https://127.0.0.1:41547/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

- Install Cilium
```
helm repo add cilium https://helm.cilium.io/

helm install cilium cilium/cilium --version 1.17.3 --namespace kube-system --set image.pullPolicy=IfNotPresent --set ipam.mode=kubernetes
```
