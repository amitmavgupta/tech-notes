# Amazon EKS Commands

## List EKS Node Groups

```bash
eksctl get nodegroup ng-1 --region ap-southeast-2 --cluster=cluster1
```

Output:
```
CLUSTER		NODEGROUP	STATUS	CREATED			MIN SIZE	MAX SIZE	DESIRED CAPACITY	INSTANCE TYPE	IMAGE ID	ASG NAME					TYPE
cluster1	ng-1		ACTIVE	2024-03-10T16:13:06Z	2		2		2			m5.large	AL2_x86_64	eks-ng-1-54c71491-cd91-5c20-0e4c-bb39fea7a7b7	managed
```

## Upgrade EKS Cluster

```bash
eksctl upgrade cluster --name cluster1 --region ap-southeast-2 --version 1.29 --approve
```

## Upgrade EKS Node Group

```bash
eksctl upgrade nodegroup \
  --name=ng-1 \
  --cluster=cluster1 \
  --region=ap-southeast-2 \
  --kubernetes-version=1.29
```

## Add a Node to a Node Group

```bash
eksctl scale nodegroup ng-1 --cluster cluster1 --nodes 2 --nodes-min 2 --nodes-max 2 --region ap-southeast-2 -w
```

Output:
```
2024-07-03 16:23:38 [ℹ]  scaling nodegroup "ng-1" in cluster cluster1
2024-07-03 16:23:40 [ℹ]  initiated scaling of nodegroup
2024-07-03 16:23:40 [ℹ]  waiting for scaling of nodegroup "ng-1" to complete
2024-07-03 16:24:49 [ℹ]  nodegroup successfully scaled
```

## Update kubeconfig

```bash
aws eks update-kubeconfig --region ap-southeast-2 --name cluster1
```

## Debug a Node

```bash
kubectl debug node/ip-192-168-108-222.ap-southeast-2.compute.internal -it --image=ubuntu
```

## Delete Debug Pod

```bash
kubectl delete pod node-debugger-ip-192-168-108-222.ap-southeast-2.compute.internal-n6jjq --now
```

## Check AWS VPC CNI Version

```bash
kubectl describe daemonset aws-node --namespace kube-system | grep amazon-k8s-cni: | cut -d : -f 3
```

Output:
```
v1.16.0-eksbuild.1
```

## List GPU-Based Nodes

```bash
kubectl describe nodes  |  tr -d '\000' | sed -n -e '/^Name/,/Roles/p' -e '/^Capacity/,/Allocatable/p' -e '/^Allocated resources/,/Events/p'  | grep -e Name  -e  nvidia.com  | perl -pe 's/\n//'  |  perl -pe 's/Name:/\n/g' | sed 's/nvidia.com\/gpu:\?//g'  | sed '1s/^/Node Available(GPUs)  Used(GPUs)/' | sed 's/$/ 0 0 0/'  | awk '{print $1, $2, $3}'  | column -t
```
