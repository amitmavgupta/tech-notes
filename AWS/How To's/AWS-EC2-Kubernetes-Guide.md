# AWS EC2 and Kubernetes Operations Guide

Comprehensive guide for EC2 instance management, Kubernetes integration, and infrastructure operations on AWS.

---

## EC2 Instance Types for Kubernetes

### Find ARM-Based EC2 Instances

```bash
aws ec2 describe-instance-types \
  --filters "Name=current-generation,Values=true" \
  "Name=vcpu-info.default-vcpus,Values=2" \
  "Name=memory-info.size-in-mib,Values=4096" \
  "Name=processor-info.supported-architecture,Values=arm64" \
  --query "InstanceTypes[*].InstanceType"
```

**Example output:**
```json
[
    "t4g.medium",
    "c6g.large",
    "c7g.large",
    "c6gn.large",
    "c6gd.large"
]
```

### Find Network Bandwidth per Instance Type

Query bandwidth support for a specific instance type family (e.g., `m4`):

```bash
aws ec2 describe-instance-types \
    --filters "Name=instance-type,Values=m4.*" \
    --query "InstanceTypes[].[InstanceType, NetworkInfo.NetworkPerformance, NetworkInfo.NetworkCards[0].BaselineBandwidthInGbps] | sort_by(@,&[2])" \
    --output table
```

**Example output:**
```
---------------------------------------
|        DescribeInstanceTypes        |
+--------------+--------------+-------+
|  m4.large    |  Moderate    |  0.45 |
|  m4.xlarge   |  High        |  0.75 |
|  m4.2xlarge  |  High        |  1.0  |
|  m4.4xlarge  |  High        |  2.0  |
|  m4.10xlarge |  10 Gigabit  |  10.0 |
|  m4.16xlarge |  25 Gigabit  |  25.0 |
+--------------+--------------+-------+
```

---

## EC2 Instance Information

### Find EC2 Instance ID via Kubernetes

Retrieve instance IDs for all nodes in your Kubernetes cluster:

```bash
kubectl get nodes -o=custom-columns=NODE:.metadata.name,ARCH:.status.nodeInfo.architecture,OS-Image:.status.nodeInfo.osImage,OS:.status.nodeInfo.operatingSystem,InstanceId:.spec.providerID
```

**Example output:**
```
NODE                                                 ARCH    OS-Image                       OS      InstanceId
ip-X-X-X-X.ap-northeast-2.compute.internal    amd64   Amazon Linux 2023.7.20250331   linux   aws:///ap-northeast-2b/i-0452f8062951459a9
ip-X-X-X-X.ap-northeast-2.compute.internal   amd64   Amazon Linux 2023.7.20250331   linux   aws:///ap-northeast-2c/i-014aa14199d9ff3de
```

### Find EC2 Instance Names

Query running EC2 instances and display their names:

```bash
aws ec2 describe-instances \
    --query "Reservations[*].Instances[*].{Name:Tags[?Key=='Name']|[0].Value,Status:State.Name}" \
    --filters "Name=instance-state-name,Values=running" \
    --output table
```

**Example output:**
```
------------------------------------------
|            DescribeInstances           |
+----------------------------+-----------+
|            Name            |  Status   |
+----------------------------+-----------+
|  cluster2-ng-1-Node        |  running  |
|  cluster2-ng-e17b91c9-Node |  running  |
|  cluster2-ng-1-Node        |  running  |
|  cluster2-ng-e17b91c9-Node |  running  |
+----------------------------+-----------+
```

---

## Kubernetes Node Architecture

### Check Node Architecture

Verify the processor architecture of all nodes in your cluster:

```bash
kubectl get no -L kubernetes.io/arch
```

**Example output:**
```
NAME                                                 STATUS   ROLES    AGE   VERSION                ARCH
ip-X-X-X-X.ap-northeast-2.compute.internal          Ready    <none>   57m   v1.29.12-eks-aeac579   arm64
ip-X-X-X-X.ap-northeast-2.compute.internal          Ready    <none>   57m   v1.29.12-eks-aeac579   arm64
```

---

## EKS - Elastic Kubernetes Service

### Enable EBS CSI Driver for EKS Cluster

#### Prerequisites
- Go to AWS Console → IAM → Roles
- Search for your node group name and select it
- Under Permissions, click "Add permissions" from the dropdown
- Search for "EBS" in the policy list
- Attach "AmazonEBSCSIDriverPolicy"

#### Install the EBS CSI Driver

```bash
kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master"
```

---

## EC2 Metadata Retrieval

### Retrieve AWS Region from EC2 Instance

Get the region from EC2 metadata using the metadata service:

```bash
ec2-metadata --availability-zone | awk '{print substr($2, 1, length($2)-1)}'
```

### Store Region in Configuration File

Store the region in a configuration file (requires root):

```bash
sudo bash -c "echo $(ec2-metadata --availability-zone | awk '{print substr($2, 1, length($2)-1)}') > /etc/tetragon/tetragon.conf.d/aws-sonar-region"
```

### Retrieve Full Instance Metadata

Use the IMDSv2 token to query instance metadata:

```bash
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`

curl -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/dynamic/instance-identity/document
```

**Example output:**
```json
{
  "accountId" : "###############",
  "architecture" : "x86_64",
  "availabilityZone" : "ap-northeast-2a",
  "billingProducts" : null,
  "devpayProductCodes" : null,
  "marketplaceProductCodes" : null,
  "imageId" : "ami-#################",
  "instanceId" : "i-06b751d334fb71262",
  "instanceType" : "t3.medium",
  "kernelId" : null,
  "pendingTime" : "2025-01-21T05:46:25Z",
  "privateIp" : "172.31.15.63",
  "ramdiskId" : null,
  "region" : "ap-northeast-2",
  "version" : "2017-09-30"
}
```

---

## Notes

- All EC2 queries use the AWS CLI v2
- Kubernetes commands assume `kubectl` is configured with the appropriate cluster context
- IMDSv2 (Instance Metadata Service Version 2) is the recommended approach for token-based access
- ARM-based instances offer cost-effective alternatives for compatible workloads
- EBS CSI driver is required for persistent volumes in EKS clusters
