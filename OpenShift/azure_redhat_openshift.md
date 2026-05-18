# Azure Red Hat OpenShift (ARO) - Cluster Deployment Guide

The Microsoft Azure Red Hat OpenShift (ARO) service enables you to deploy fully managed OpenShift clusters on Azure. Azure Red Hat OpenShift extends Kubernetes with enterprise features, lifecycle management, and integrated security controls.

---

## Overview

ARO is a fully managed service that handles OpenShift control plane operations (API server, etcd, scheduling) while you manage worker nodes. The service includes:
- **Automated updates and patches** for control plane components
- **Integrated Azure services** (identity, networking, storage, monitoring)
- **OVN-based networking** with Geneve overlay protocol
- **Built-in observability** with Azure Monitor integration
- **Enterprise support** and SLAs

---

## Pre-Requisites
- You should have an Azure Subscription.
- Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/).
- Install [openshift client](https://docs.redhat.com/en/documentation/openshift_container_platform/4.8/html/cli_tools/openshift-cli-oc#cli-getting-started)
- Ensure you have enough quota resources to create an AKS cluster. Go to the Subscription blade, navigate to “Usage + Quotas”, and make sure you have enough quota for the following resources:
    - Azure Red Hat OpenShift requires at least 40 cores to create and run a cluster. The default Azure resource quota for a new Azure subscription is only 10.

## CNI support
- Since ARO is based out of OVN, it uses the Generic Network Virtualization Encapsulation (Geneve) protocol rather than the Virtual Extensible LAN (VXLAN) protocol to create an overlay network between nodes.
- Support for OpenShift SDN is deprecated.
- Support for [3rd party CNI](https://access.redhat.com/solutions/7029059) is pending.

## Register the resource providers
```
az provider register -n Microsoft.RedHatOpenShift --wait
az provider register -n Microsoft.Compute --wait
az provider register -n Microsoft.Storage --wait
az provider register -n Microsoft.Authorization --wait
```

## Get a Red Hat pull secret
- Log in to the Red Hat Hybrid Cloud Console to access the Azure Red Hat OpenShift pull secret page. 
- Click Download pull secret and save the pull secret in a secure place as a .txt file. You’ll reference it later.

## Variables and resource groups
- Set the following environment variables. 
```
AZR_RESOURCE_LOCATION=canadacentral
AZR_RESOURCE_GROUP=openshift
AZR_CLUSTER=cluster
AZR_PULL_SECRET=~/Downloads/pull-secret.txt
```
- Create a Resource Group
```
az group create \
  --name $AZR_RESOURCE_GROUP \
  --location $AZR_RESOURCE_LOCATION
{
  "id": "/subscriptions/################################/resourceGroups/openshift",
  "location": "canadacentral",
  "managedBy": null,
  "name": "openshift",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}
```
- In addition to this manually created Resource Group, there is another managed Resource Group that is created that contains Private Endpoints, VM's, Private Link Service Endpoints etc.

## Networking
- Create a virtual network with two empty subnets.
```
az network vnet create \
  --address-prefixes 10.0.0.0/22 \
  --name "$AZR_CLUSTER-aro-vnet-$AZR_RESOURCE_LOCATION" \
  --resource-group $AZR_RESOURCE_GROUP
{
  "newVNet": {
    "addressSpace": {
      "addressPrefixes": [
        "10.0.0.0/22"
      ]
    },
    "enableDdosProtection": false,
    "etag": "W/\"################################\"",
    "id": "/subscriptions/################################/resourceGroups/openshift/providers/Microsoft.Network/virtualNetworks/cluster-aro-vnet-canadacentral",
    "location": "canadacentral",
    "name": "cluster-aro-vnet-canadacentral",
    "privateEndpointVNetPolicies": "Disabled",
    "provisioningState": "Succeeded",
    "resourceGroup": "openshift",
    "resourceGuid": "################################",
    "subnets": [],
    "type": "Microsoft.Network/virtualNetworks",
    "virtualNetworkPeerings": []
  }
}
```
- Create the control plane subnet.
```
az network vnet subnet create \
  --resource-group $AZR_RESOURCE_GROUP \
  --vnet-name "$AZR_CLUSTER-aro-vnet-$AZR_RESOURCE_LOCATION" \
  --name "$AZR_CLUSTER-aro-control-subnet-$AZR_RESOURCE_LOCATION" \
  --address-prefixes 10.0.0.0/23 \
  --service-endpoints Microsoft.ContainerRegistry
{
  "addressPrefix": "10.0.0.0/23",
  "delegations": [],
  "etag": "W/\"################################\"",
  "id": "/subscriptions/################################/resourceGroups/openshift/providers/Microsoft.Network/virtualNetworks/cluster-aro-vnet-canadacentral/subnets/cluster-aro-control-subnet-canadacentral",
  "name": "cluster-aro-control-subnet-canadacentral",
  "privateEndpointNetworkPolicies": "Disabled",
  "privateLinkServiceNetworkPolicies": "Enabled",
  "provisioningState": "Succeeded",
  "resourceGroup": "openshift",
  "serviceEndpoints": [
    {
      "locations": [
        "*"
      ],
      "provisioningState": "Succeeded",
      "service": "Microsoft.ContainerRegistry"
    }
  ],
  "type": "Microsoft.Network/virtualNetworks/subnets"
}
```
- Create the machine subnet.
```
az network vnet subnet create \
  --resource-group $AZR_RESOURCE_GROUP \
  --vnet-name "$AZR_CLUSTER-aro-vnet-$AZR_RESOURCE_LOCATION" \
  --name "$AZR_CLUSTER-aro-machine-subnet-$AZR_RESOURCE_LOCATION" \
  --address-prefixes 10.0.2.0/23 \
  --service-endpoints Microsoft.ContainerRegistry
{
  "addressPrefix": "10.0.2.0/23",
  "delegations": [],
  "etag": "W/\"################################\"",
  "id": "/subscriptions/################################/resourceGroups/openshift/providers/Microsoft.Network/virtualNetworks/cluster-aro-vnet-canadacentral/subnets/cluster-aro-machine-subnet-canadacentral",
  "name": "cluster-aro-machine-subnet-canadacentral",
  "privateEndpointNetworkPolicies": "Disabled",
  "privateLinkServiceNetworkPolicies": "Enabled",
  "provisioningState": "Succeeded",
  "resourceGroup": "openshift",
  "serviceEndpoints": [
    {
      "locations": [
        "*"
      ],
      "provisioningState": "Succeeded",
      "service": "Microsoft.ContainerRegistry"
    }
  ],
  "type": "Microsoft.Network/virtualNetworks/subnets"
}
```
- Disable network policies on the control plane subnet. This is required for the service to be able to connect to and manage the cluster.
```
az network vnet subnet update \
  --name "$AZR_CLUSTER-aro-control-subnet-$AZR_RESOURCE_LOCATION" \
  --resource-group $AZR_RESOURCE_GROUP \
  --vnet-name "$AZR_CLUSTER-aro-vnet-$AZR_RESOURCE_LOCATION" \
  --disable-private-link-service-network-policies true
`--disable-private-link-service-network-policies` will be deprecated in the future, if you wanna disable network policy for private link service, please use `--private-link-service-network-policies Disabled` instead.
{
  "addressPrefix": "10.0.0.0/23",
  "delegations": [],
  "etag": "W/\"################################\"",
  "id": "/subscriptions/################################/resourceGroups/openshift/providers/Microsoft.Network/virtualNetworks/cluster-aro-vnet-canadacentral/subnets/cluster-aro-control-subnet-canadacentral",
  "name": "cluster-aro-control-subnet-canadacentral",
  "privateEndpointNetworkPolicies": "Disabled",
  "privateLinkServiceNetworkPolicies": "Disabled",
  "provisioningState": "Succeeded",
  "resourceGroup": "openshift",
  "serviceEndpoints": [
    {
      "locations": [
        "*"
      ],
      "provisioningState": "Succeeded",
      "service": "Microsoft.ContainerRegistry"
    }
  ],
  "type": "Microsoft.Network/virtualNetworks/subnets"
}
```
## Create the ARO cluster
```
az aro create \
  --resource-group $AZR_RESOURCE_GROUP \
  --name $AZR_CLUSTER \
  --vnet "$AZR_CLUSTER-aro-vnet-$AZR_RESOURCE_LOCATION" \
  --master-subnet "$AZR_CLUSTER-aro-control-subnet-$AZR_RESOURCE_LOCATION" \
  --worker-subnet "$AZR_CLUSTER-aro-machine-subnet-$AZR_RESOURCE_LOCATION" \
  --pull-secret @$AZR_PULL_SECRET
```
- Get the OpenShift console URL.
```
az aro show \
  --name $AZR_CLUSTER \
  --resource-group $AZR_RESOURCE_GROUP \
  -o tsv --query consoleProfile
https://console-openshift-console.apps.##########.canadacentral.aroapp.io/
```
- Get your OpenShift credentials.
```
az aro list-credentials \
  --name $AZR_CLUSTER \
  --resource-group $AZR_RESOURCE_GROUP \
  -o tsv
#############################	kubeadmin
```
- Use the URL and the credentials provided by the output of the last two commands to log into OpenShift via a web browser. Here, you can monitor and update your cluster as needed.

## Check the nodes and pods
```
oc get nodes -o wide -A
NAME                                        STATUS   ROLES                  AGE   VERSION            INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                                                       KERNEL-VERSION                 CONTAINER-RUNTIME
cluster-797pp-master-0                      Ready    control-plane,master   13h   v1.28.13+2ca1a23   10.0.0.10     <none>        Red Hat Enterprise Linux CoreOS 415.92.202409241719-0 (Plow)   5.14.0-284.86.1.el9_2.x86_64   cri-o://1.28.10-5.rhaos4.15.git7a788e6.el9
cluster-797pp-master-1                      Ready    control-plane,master   13h   v1.28.13+2ca1a23   10.0.0.8      <none>        Red Hat Enterprise Linux CoreOS 415.92.202409241719-0 (Plow)   5.14.0-284.86.1.el9_2.x86_64   cri-o://1.28.10-5.rhaos4.15.git7a788e6.el9
cluster-797pp-master-2                      Ready    control-plane,master   13h   v1.28.13+2ca1a23   10.0.0.9      <none>        Red Hat Enterprise Linux CoreOS 415.92.202409241719-0 (Plow)   5.14.0-284.86.1.el9_2.x86_64   cri-o://1.28.10-5.rhaos4.15.git7a788e6.el9
cluster-797pp-worker-canadacentral1-dnw2p   Ready    worker                 13h   v1.28.13+2ca1a23   10.0.2.4      <none>        Red Hat Enterprise Linux CoreOS 415.92.202409241719-0 (Plow)   5.14.0-284.86.1.el9_2.x86_64   cri-o://1.28.10-5.rhaos4.15.git7a788e6.el9
cluster-797pp-worker-canadacentral2-5qbbl   Ready    worker                 13h   v1.28.13+2ca1a23   10.0.2.6      <none>        Red Hat Enterprise Linux CoreOS 415.92.202409241719-0 (Plow)   5.14.0-284.86.1.el9_2.x86_64   cri-o://1.28.10-5.rhaos4.15.git7a788e6.el9
cluster-797pp-worker-canadacentral3-sqvbs   Ready    worker                 13h   v1.28.13+2ca1a23   10.0.2.5      <none>        Red Hat Enterprise Linux CoreOS 415.92.202409241719-0 (Plow)   5.14.0-284.86.1.el9_2.x86_64   cri-o://1.28.10-5.rhaos4.15.git7a788e6.el9
```
```
oc get pods -A -o wide
NAMESPACE                                          NAME                                                             READY   STATUS                   RESTARTS       AGE     IP             NODE                                        NOMINATED NODE   READINESS GATES
openshift-apiserver-operator                       openshift-apiserver-operator-67bb775974-fqtkz                    1/1     Running                  0              13h     10.130.0.29    cluster-797pp-master-1                      <none>           <none>
openshift-apiserver                                apiserver-b54fcf7c9-h4d7f                                        2/2     Running                  0              13h     10.130.0.13    cluster-797pp-master-1                      <none>           <none>
openshift-apiserver                                apiserver-b54fcf7c9-rhvvs                                        2/2     Running                  0              13h     10.129.0.15    cluster-797pp-master-0                      <none>           <none>
openshift-apiserver                                apiserver-b54fcf7c9-sfplr                                        2/2     Running                  0              13h     10.128.0.9     cluster-797pp-master-2                      <none>           <none>
openshift-authentication-operator                  authentication-operator-855c698778-5qsj9                         1/1     Running                  0              13h     10.130.0.24    cluster-797pp-master-1                      <none>           <none>
openshift-authentication                           oauth-openshift-c48f4cbb7-425cs                                  1/1     Running                  0              13h     10.129.0.49    cluster-797pp-master-0                      <none>           <none>
openshift-authentication                           oauth-openshift-c48f4cbb7-d4qbm                                  1/1     Running                  0              13h     10.128.0.20    cluster-797pp-master-2                      <none>           <none>
openshift-authentication                           oauth-openshift-c48f4cbb7-z9h4h                                  1/1     Running                  0              13h     10.130.0.57    cluster-797pp-master-1                      <none>           <none>
openshift-azure-logging                            mdsd-bmnn8                                                       2/2     Running                  2              13h     10.129.0.62    cluster-797pp-master-0                      <none>           <none>
openshift-azure-logging                            mdsd-djpgq                                                       2/2     Running                  2              13h     10.129.2.14    cluster-797pp-worker-canadacentral1-dnw2p   <none>           <none>
openshift-azure-logging                            mdsd-gv7m9                                                       2/2     Running                  2              13h     10.130.0.68    cluster-797pp-master-1                      <none>           <none>
openshift-azure-logging                            mdsd-hpb8k                                                       2/2     Running                  0              13h     10.131.0.6     cluster-797pp-worker-canadacentral3-sqvbs   <none>           <none>
openshift-azure-logging                            mdsd-nlh64                                                       2/2     Running                  2              13h     10.128.2.17    cluster-797pp-worker-canadacentral2-5qbbl   <none>           <none>
openshift-azure-logging                            mdsd-vlz5h                                                       2/2     Running                  2              13h     10.128.0.82    cluster-797pp-master-2                      <none>           <none>
openshift-azure-operator                           aro-operator-master-6d5cb794c6-z7h6m                             1/1     Running                  0              13h     10.129.0.56    cluster-797pp-master-0                      <none>           <none>
openshift-azure-operator                           aro-operator-worker-856f955794-l5dzf                             1/1     Running                  1              13h     10.131.0.21    cluster-797pp-worker-canadacentral3-sqvbs   <none>           <none>
openshift-cloud-controller-manager-operator        cluster-cloud-controller-manager-operator-67b5d8d64f-rnssv       3/3     Running                  0              13h     10.0.0.10      cluster-797pp-master-0                      <none>           <none>
openshift-cloud-controller-manager                 azure-cloud-controller-manager-d75b95c78-2bcpx                   1/1     Running                  0              13h     10.0.0.8       cluster-797pp-master-1                      <none>           <none>
openshift-cloud-controller-manager                 azure-cloud-controller-manager-d75b95c78-66rjd                   1/1     Running                  0              13h     10.0.0.10      cluster-797pp-master-0                      <none>           <none>
openshift-cloud-controller-manager                 azure-cloud-node-manager-96wsx                                   1/1     Running                  1              14h     10.0.0.9       cluster-797pp-master-2                      <none>           <none>
openshift-cloud-controller-manager                 azure-cloud-node-manager-9tzs8                                   1/1     Running                  1              14h     10.0.0.8       cluster-797pp-master-1                      <none>           <none>
openshift-cloud-controller-manager                 azure-cloud-node-manager-jnxjg                                   1/1     Running                  1              14h     10.0.2.5       cluster-797pp-worker-canadacentral3-sqvbs   <none>           <none>
openshift-cloud-controller-manager                 azure-cloud-node-manager-n6v8g                                   1/1     Running                  1              14h     10.0.0.10      cluster-797pp-master-0                      <none>           <none>
openshift-cloud-controller-manager                 azure-cloud-node-manager-qnv56                                   1/1     Running                  1              14h     10.0.2.4       cluster-797pp-worker-canadacentral1-dnw2p   <none>           <none>
openshift-cloud-controller-manager                 azure-cloud-node-manager-qpqkv                                   1/1     Running                  2              14h     10.0.2.6       cluster-797pp-worker-canadacentral2-5qbbl   <none>           <none>
openshift-cloud-credential-operator                cloud-credential-operator-84fbf8c48-sgtv4                        2/2     Running                  0              13h     10.128.0.34    cluster-797pp-master-2                      <none>           <none>
openshift-cloud-network-config-controller          cloud-network-config-controller-f54485ffb-rqnj9                  1/1     Running                  0              13h     10.130.0.18    cluster-797pp-master-1                      <none>           <none>
openshift-cluster-csi-drivers                      azure-disk-csi-driver-controller-c778fb4cd-9rtdr                 11/11   Running                  0              13h     10.0.0.10      cluster-797pp-master-0                      <none>           <none>
openshift-cluster-csi-drivers                      azure-disk-csi-driver-controller-c778fb4cd-wxr9k                 11/11   Running                  0              13h     10.0.0.8       cluster-797pp-master-1                      <none>           <none>
openshift-cluster-csi-drivers                      azure-disk-csi-driver-node-hkrjm                                 3/3     Running                  3              14h     10.0.2.5       cluster-797pp-worker-canadacentral3-sqvbs   <none>           <none>
openshift-cluster-csi-drivers                      azure-disk-csi-driver-node-jkcmp                                 3/3     Running                  3              14h     10.0.2.6       cluster-797pp-worker-canadacentral2-5qbbl   <none>           <none>
openshift-cluster-csi-drivers                      azure-disk-csi-driver-node-m6wgd                                 3/3     Running                  3              14h     10.0.0.9       cluster-797pp-master-2                      <none>           <none>
openshift-cluster-csi-drivers                      azure-disk-csi-driver-node-ng985                                 3/3     Running                  3              14h     10.0.0.8       cluster-797pp-master-1                      <none>           <none>
openshift-cluster-csi-drivers                      azure-disk-csi-driver-node-r4ptj                                 3/3     Running                  3              14h     10.0.2.4       cluster-797pp-worker-canadacentral1-dnw2p   <none>           <none>
openshift-cluster-csi-drivers                      azure-disk-csi-driver-node-vh9vt                                 3/3     Running                  3              14h     10.0.0.10      cluster-797pp-master-0                      <none>           <none>
openshift-cluster-csi-drivers                      azure-disk-csi-driver-operator-78c5c5f89d-8q4gg                  1/1     Running                  0              13h     10.129.0.31    cluster-797pp-master-0                      <none>           <none>
openshift-cluster-csi-drivers                      azure-file-csi-driver-controller-7d55bdf4c4-r6glb                9/9     Running                  0              13h     10.0.0.10      cluster-797pp-master-0                      <none>           <none>
openshift-cluster-csi-drivers                      azure-file-csi-driver-controller-7d55bdf4c4-z5rh8                9/9     Running                  0              13h     10.0.0.8       cluster-797pp-master-1                      <none>           <none>
openshift-cluster-csi-drivers                      azure-file-csi-driver-node-95tpq                                 3/3     Running                  3              14h     10.0.2.4       cluster-797pp-worker-canadacentral1-dnw2p   <none>           <none>
openshift-cluster-csi-drivers                      azure-file-csi-driver-node-d5wbj                                 3/3     Running                  3              14h     10.0.2.6       cluster-797pp-worker-canadacentral2-5qbbl   <none>           <none>
openshift-cluster-csi-drivers                      azure-file-csi-driver-node-jgdmm                                 3/3     Running                  3              14h     10.0.0.8       cluster-797pp-master-1                      <none>           <none>
openshift-cluster-csi-drivers                      azure-file-csi-driver-node-n8c92                                 3/3     Running                  3              14h     10.0.0.10      cluster-797pp-master-0                      <none>           <none>
openshift-cluster-csi-drivers                      azure-file-csi-driver-node-pwhsl                                 3/3     Running                  3              14h     10.0.0.9       cluster-797pp-master-2                      <none>           <none>
openshift-cluster-csi-drivers                      azure-file-csi-driver-node-s6p79                                 3/3     Running                  3              14h     10.0.2.5       cluster-797pp-worker-canadacentral3-sqvbs   <none>           <none>
openshift-cluster-csi-drivers                      azure-file-csi-driver-operator-6b78bc7854-t7kpl                  1/1     Running                  0              13h     10.129.0.33    cluster-797pp-master-0                      <none>           <none>
openshift-cluster-machine-approver                 machine-approver-5594646b58-rndgm                                2/2     Running                  0              13h     10.0.0.8       cluster-797pp-master-1                      <none>           <none>
openshift-cluster-node-tuning-operator             cluster-node-tuning-operator-9955c7c64-l2c8z                     1/1     Running                  0              13h     10.130.0.36    cluster-797pp-master-1                      <none>           <none>
openshift-cluster-node-tuning-operator             tuned-2cjcn                                                      1/1     Running                  1              14h     10.0.2.5       cluster-797pp-worker-canadacentral3-sqvbs   <none>           <none>
openshift-cluster-node-tuning-operator             tuned-8jzn7                                                      1/1     Running                  1              14h     10.0.2.4       cluster-797pp-worker-canadacentral1-dnw2p   <none>           <none>
openshift-cluster-node-tuning-operator             tuned-bvxj7                                                      1/1     Running                  1              14h     10.0.2.6       cluster-797pp-worker-canadacentral2-5qbbl   <none>           <none>
openshift-cluster-node-tuning-operator             tuned-hddhn                                                      1/1     Running                  1              14h     10.0.0.8       cluster-797pp-master-1                      <none>           <none>
openshift-cluster-node-tuning-operator             tuned-qw4ds                                                      1/1     Running                  1              14h     10.0.0.10      cluster-797pp-master-0                      <none>           <none>
openshift-cluster-node-tuning-operator             tuned-zlszb                                                      1/1     Running                  1              14h     10.0.0.9       cluster-797pp-master-2                      <none>           <none>
openshift-cluster-samples-operator                 cluster-samples-operator-75b8cf687f-7rx6t                        2/2     Running                  0              13h     10.130.0.39    cluster-797pp-master-1                      <none>           <none>
openshift-cluster-storage-operator                 cluster-storage-operator-7b457996c4-72r77                        1/1     Running                  0              13h     10.130.0.19    cluster-797pp-master-1                      <none>           <none>
openshift-cluster-storage-operator                 csi-snapshot-controller-77fd9ffd67-kl8mc                         1/1     Running                  0              13h     10.130.0.44    cluster-797pp-master-1                      <none>           <none>
openshift-cluster-storage-operator                 csi-snapshot-controller-77fd9ffd67-kqbsq                         1/1     Running                  0              13h     10.129.0.20    cluster-797pp-master-0                      <none>           <none>
openshift-cluster-storage-operator                 csi-snapshot-controller-operator-66cf87d7d6-kj4gn                1/1     Running                  0              13h     10.130.0.37    cluster-797pp-master-1                      <none>           <none>
openshift-cluster-storage-operator                 csi-snapshot-webhook-6cbf8798fb-qzm46                            1/1     Running                  0              13h     10.130.0.45    cluster-797pp-master-1                      <none>           <none>
openshift-cluster-storage-operator                 csi-snapshot-webhook-6cbf8798fb-wqjpk                            1/1     Running                  0              13h     10.129.0.21    cluster-797pp-master-0                      <none>           <none>
openshift-cluster-version                          cluster-version-operator-67bbd7d78-m4njd                         1/1     Running                  0              13h     10.0.0.9       cluster-797pp-master-2                      <none>           <none>
openshift-cluster-version                          version-4.15.35-mlwbq-m9qkh                                      0/1     Completed                0              13h     10.129.0.45    cluster-797pp-master-0                      <none>           <none>
openshift-config-operator                          openshift-config-operator-69d75585c4-ljppk                       1/1     Running                  0              13h     10.129.0.40    cluster-797pp-master-0                      <none>           <none>
openshift-console-operator                         console-operator-55fd655d-bmchj                                  2/2     Running                  0              13h     10.129.0.29    cluster-797pp-master-0                      <none>           <none>
openshift-console                                  console-7847556475-6f2x6                                         1/1     Running                  0              13h     10.128.0.21    cluster-797pp-master-2                      <none>           <none>
openshift-console                                  console-7847556475-8fdcs                                         1/1     Running                  0              13h     10.130.0.56    cluster-797pp-master-1                      <none>           <none>
openshift-console                                  downloads-5cc8498757-j26rg                                       1/1     Running                  0              13h     10.129.0.22    cluster-797pp-master-0                      <none>           <none>
openshift-console                                  downloads-5cc8498757-nj7bj                                       1/1     Running                  0              13h     10.130.0.22    cluster-797pp-master-1                      <none>           <none>
openshift-controller-manager-operator              openshift-controller-manager-operator-6bdd498497-qj2ds           1/1     Running                  0              13h     10.130.0.27    cluster-797pp-master-1                      <none>           <none>
openshift-controller-manager                       controller-manager-5d5b4c75dd-5rswd                              1/1     Running                  0              13h     10.130.0.11    cluster-797pp-master-1                      <none>           <none>
openshift-controller-manager                       controller-manager-5d5b4c75dd-ctztk                              1/1     Running                  0              13h     10.128.0.10    cluster-797pp-master-2                      <none>           <none>
openshift-controller-manager                       controller-manager-5d5b4c75dd-gbkxg                              1/1     Running                  0              13h     10.129.0.18    cluster-797pp-master-0                      <none>           <none>
openshift-dns-operator                             dns-operator-759679655d-vv9xh                                    2/2     Running                  0              13h     10.130.0.20    cluster-797pp-master-1                      <none>           <none>
openshift-dns                                      dns-default-79jnf                                                2/2     Running                  2              14h     10.131.0.7     cluster-797pp-worker-canadacentral3-sqvbs   <none>           <none>
openshift-dns                                      dns-default-c5d9f                                                2/2     Running                  2              14h     10.128.2.5     cluster-797pp-worker-canadacentral2-5qbbl   <none>           <none>
openshift-dns                                      dns-default-krmdp                                                2/2     Running                  2              14h     10.130.0.5     cluster-797pp-master-1                      <none>           <none>
openshift-dns                                      dns-default-lqspl                                                2/2     Running                  2              14h     10.129.2.6     cluster-797pp-worker-canadacentral1-dnw2p   <none>           <none>
openshift-dns                                      dns-default-mzxsv                                                2/2     Running                  2              14h     10.128.0.37    cluster-797pp-master-2                      <none>           <none>
openshift-dns                                      dns-default-t4mnr                                                2/2     Running                  2              14h     10.129.0.10    cluster-797pp-master-0                      <none>           <none>
openshift-dns                                      node-resolver-6kd9g                                              1/1     Running                  1              14h     10.0.2.5       cluster-797pp-worker-canadacentral3-sqvbs   <none>           <none>
openshift-dns                                      node-resolver-fpw5z                                              1/1     Running                  1              14h     10.0.2.4       cluster-797pp-worker-canadacentral1-dnw2p   <none>           <none>
openshift-dns                                      node-resolver-gjpww                                              1/1     Running                  1              14h     10.0.0.8       cluster-797pp-master-1                      <none>           <none>
openshift-dns                                      node-resolver-kfrjn                                              1/1     Running                  1              14h     10.0.0.10      cluster-797pp-master-0                      <none>           <none>
openshift-dns                                      node-resolver-qlrbq                                              1/1     Running                  1              14h     10.0.2.6       cluster-797pp-worker-canadacentral2-5qbbl   <none>           <none>
openshift-dns                                      node-resolver-wktx4                                              1/1     Running                  1              14h     10.0.0.9       cluster-797pp-master-2                      <none>           <none>
openshift-etcd-operator                            etcd-operator-5f4d596578-6gmpj                                   1/1     Running                  0              13h     10.130.0.25    cluster-797pp-master-1                      <none>           <none>
openshift-etcd                                     etcd-cluster-797pp-master-0                                      4/4     Running                  4              14h     10.0.0.10      cluster-797pp-master-0                      <none>           <none>
openshift-etcd                                     etcd-cluster-797pp-master-1                                      4/4     Running                  4              13h     10.0.0.8       cluster-797pp-master-1                      <none>           <none>
openshift-etcd                                     etcd-cluster-797pp-master-2                                      4/4     Running                  4              13h     10.0.0.9       cluster-797pp-master-2                      <none>           <none>
openshift-etcd                                     etcd-guard-cluster-797pp-master-0                                1/1     Running                  0              13h     10.129.0.13    cluster-797pp-master-0                      <none>           <none>
openshift-etcd                                     etcd-guard-cluster-797pp-master-1                                1/1     Running                  0              13h     10.130.0.16    cluster-797pp-master-1                      <none>           <none>
openshift-etcd                                     etcd-guard-cluster-797pp-master-2                                1/1     Running                  0              13h     10.128.0.17    cluster-797pp-master-2                      <none>           <none>
openshift-etcd                                     revision-pruner-8-cluster-797pp-master-0                         0/1     Completed                0              13h     10.129.0.7     cluster-797pp-master-0                      <none>           <none>
openshift-etcd                                     revision-pruner-8-cluster-797pp-master-1                         0/1     Completed                0              13h     10.130.0.8     cluster-797pp-master-1                      <none>           <none>
openshift-etcd                                     revision-pruner-8-cluster-797pp-master-2                         0/1     Completed                0              13h     10.128.0.7     cluster-797pp-master-2                      <none>           <none>
openshift-image-registry                           cluster-image-registry-operator-549d6d6b9c-b2bk8                 1/1     Running                  0              13h     10.130.0.41    cluster-797pp-master-1                      <none>           <none>
openshift-image-registry                           image-pruner-29129760-2vshd                                      0/1     Completed                0              5h23m   10.131.0.10    cluster-797pp-worker-canadacentral3-sqvbs   <none>           <none>
openshift-image-registry                           image-registry-66d967f87f-8w946                                  1/1     Running                  0              13h     10.128.2.20    cluster-797pp-worker-canadacentral2-5qbbl   <none>           <none>
openshift-image-registry                           image-registry-66d967f87f-j8ccv                                  1/1     Running                  0              13h     10.131.0.8     cluster-797pp-worker-canadacentral3-sqvbs   <none>           <none>
openshift-image-registry                           node-ca-9hh2z                                                    1/1     Running                  1              14h     10.0.0.9       cluster-797pp-master-2                      <none>           <none>
openshift-image-registry                           node-ca-c77rm                                                    1/1     Running                  1              14h     10.0.0.10      cluster-797pp-master-0                      <none>           <none>
openshift-image-registry                           node-ca-sd5fq                                                    1/1     Running                  1              14h     10.0.2.4       cluster-797pp-worker-canadacentral1-dnw2p   <none>           <none>
openshift-image-registry                           node-ca-vcs6l                                                    1/1     Running                  1              14h     10.0.0.8       cluster-797pp-master-1                      <none>           <none>
openshift-image-registry                           node-ca-wsm9g                                                    1/1     Running                  1              14h     10.0.2.5       cluster-797pp-worker-canadacentral3-sqvbs   <none>           <none>
openshift-image-registry                           node-ca-wzbhj                                                    1/1     Running                  1              14h     10.0.2.6       cluster-797pp-worker-canadacentral2-5qbbl   <none>           <none>
openshift-ingress-canary                           ingress-canary-l6pvg                                             1/1     Running                  1              14h     10.129.2.9     cluster-797pp-worker-canadacentral1-dnw2p   <none>           <none>
openshift-ingress-canary                           ingress-canary-l9bqj                                             1/1     Running                  1              14h     10.131.0.9     cluster-797pp-worker-canadacentral3-sqvbs   <none>           <none>
openshift-ingress-canary                           ingress-canary-rnw8v                                             1/1     Running                  1              14h     10.128.2.8     cluster-797pp-worker-canadacentral2-5qbbl   <none>           <none>
openshift-ingress-operator                         ingress-operator-5455c7f8bd-hq7l4                                2/2     Running                  0              13h     10.130.0.34    cluster-797pp-master-1                      <none>           <none>
openshift-ingress                                  router-default-f6bfdc9c6-6b9x4                                   1/1     Running                  0              13h     10.128.2.18    cluster-797pp-worker-canadacentral2-5qbbl   <none>           <none>
openshift-ingress                                  router-default-f6bfdc9c6-zklqc                                   1/1     Running                  0              13h     10.129.2.19    cluster-797pp-worker-canadacentral1-dnw2p   <none>           <none>
openshift-insights                                 insights-operator-cddfb58b5-xkvmq                                1/1     Running                  0              13h     10.130.0.33    cluster-797pp-master-1                      <none>           <none>
openshift-kube-apiserver-operator                  kube-apiserver-operator-84745d6756-vl2tg                         1/1     Running                  0              13h     10.130.0.38    cluster-797pp-master-1                      <none>           <none>
openshift-kube-apiserver                           apiserver-watcher-cluster-797pp-master-0                         1/1     Running                  1              14h     10.0.0.10      cluster-797pp-master-0                      <none>           <none>
openshift-kube-apiserver                           apiserver-watcher-cluster-797pp-master-1                         1/1     Running                  1              14h     10.0.0.8       cluster-797pp-master-1                      <none>           <none>
openshift-kube-apiserver                           apiserver-watcher-cluster-797pp-master-2                         1/1     Running                  1              14h     10.0.0.9       cluster-797pp-master-2                      <none>           <none>
openshift-kube-apiserver                           installer-10-cluster-797pp-master-0                              0/1     ContainerStatusUnknown   1              13h     <none>         cluster-797pp-master-0                      <none>           <none>
openshift-kube-apiserver                           installer-10-cluster-797pp-master-1                              0/1     Completed                0              13h     10.130.0.7     cluster-797pp-master-1                      <none>           <none>
openshift-kube-apiserver                           installer-10-cluster-797pp-master-2                              0/1     Completed                0              13h     10.128.0.5     cluster-797pp-master-2                      <none>           <none>
openshift-kube-apiserver                           installer-10-retry-1-cluster-797pp-master-0                      0/1     Completed                0              13h     10.129.0.14    cluster-797pp-master-0                      <none>           <none>
openshift-kube-apiserver                           installer-11-cluster-797pp-master-0                              0/1     Completed                0              13h     10.129.0.48    cluster-797pp-master-0                      <none>           <none>
openshift-kube-apiserver                           installer-12-cluster-797pp-master-0                              0/1     Completed                0              13h     10.129.0.55    cluster-797pp-master-0                      <none>           <none>
openshift-kube-apiserver                           installer-12-cluster-797pp-master-1                              0/1     Completed                0              13h     10.130.0.61    cluster-797pp-master-1                      <none>           <none>
openshift-kube-apiserver                           installer-12-cluster-797pp-master-2                              0/1     Completed                0              13h     10.128.0.30    cluster-797pp-master-2                      <none>           <none>
openshift-kube-apiserver                           kube-apiserver-cluster-797pp-master-0                            5/5     Running                  0              13h     10.0.0.10      cluster-797pp-master-0                      <none>           <none>
openshift-kube-apiserver                           kube-apiserver-cluster-797pp-master-1                            5/5     Running                  0              13h     10.0.0.8       cluster-797pp-master-1                      <none>           <none>
openshift-kube-apiserver                           kube-apiserver-cluster-797pp-master-2                            5/5     Running                  0              13h     10.0.0.9       cluster-797pp-master-2                      <none>           <none>
openshift-kube-apiserver                           kube-apiserver-guard-cluster-797pp-master-0                      1/1     Running                  0              13h     10.129.0.12    cluster-797pp-master-0                      <none>           <none>
openshift-kube-apiserver                           kube-apiserver-guard-cluster-797pp-master-1                      1/1     Running                  0              13h     10.130.0.15    cluster-797pp-master-1                      <none>           <none>
openshift-kube-apiserver                           kube-apiserver-guard-cluster-797pp-master-2                      1/1     Running                  0              13h     10.128.0.16    cluster-797pp-master-2                      <none>           <none>
openshift-kube-apiserver                           revision-pruner-10-cluster-797pp-master-0                        0/1     Completed                0              13h     10.129.0.8     cluster-797pp-master-0                      <none>           <none>
openshift-kube-apiserver                           revision-pruner-10-cluster-797pp-master-1                        0/1     Completed                0              13h     <none>         cluster-797pp-master-1                      <none>           <none>
openshift-kube-apiserver                           revision-pruner-10-cluster-797pp-master-2                        0/1     Completed                0              13h     10.128.0.8     cluster-797pp-master-2                      <none>           <none>
openshift-kube-apiserver                           revision-pruner-11-cluster-797pp-master-0                        0/1     Completed                0              13h     10.129.0.47    cluster-797pp-master-0                      <none>           <none>
openshift-kube-apiserver                           revision-pruner-11-cluster-797pp-master-1                        0/1     Completed                0              13h     10.130.0.55    cluster-797pp-master-1                      <none>           <none>
openshift-kube-apiserver                           revision-pruner-11-cluster-797pp-master-2                        0/1     Completed                0              13h     10.128.0.22    cluster-797pp-master-2                      <none>           <none>
openshift-kube-apiserver                           revision-pruner-12-cluster-797pp-master-0                        0/1     Completed                0              13h     10.129.0.52    cluster-797pp-master-0                      <none>           <none>
openshift-kube-apiserver                           revision-pruner-12-cluster-797pp-master-1                        0/1     Completed                0              13h     10.130.0.59    cluster-797pp-master-1                      <none>           <none>
openshift-kube-apiserver                           revision-pruner-12-cluster-797pp-master-2                        0/1     Completed                0              13h     10.128.0.27    cluster-797pp-master-2                      <none>           <none>
openshift-kube-controller-manager-operator         kube-controller-manager-operator-69f6b7d6d8-8wpvm                1/1     Running                  0              13h     10.130.0.30    cluster-797pp-master-1                      <none>           <none>
openshift-kube-controller-manager                  installer-7-cluster-797pp-master-0                               0/1     Completed                0              13h     10.129.0.5     cluster-797pp-master-0                      <none>           <none>
openshift-kube-controller-manager                  installer-8-cluster-797pp-master-0                               0/1     Completed                0              13h     10.129.0.50    cluster-797pp-master-0                      <none>           <none>
openshift-kube-controller-manager                  installer-8-cluster-797pp-master-1                               0/1     Completed                0              13h     10.130.0.54    cluster-797pp-master-1                      <none>           <none>
openshift-kube-controller-manager                  installer-8-cluster-797pp-master-2                               0/1     Completed                0              13h     10.128.0.23    cluster-797pp-master-2                      <none>           <none>
openshift-kube-controller-manager                  installer-9-cluster-797pp-master-0                               0/1     Completed                0              13h     10.129.0.54    cluster-797pp-master-0                      <none>           <none>
openshift-kube-controller-manager                  installer-9-cluster-797pp-master-1                               0/1     Completed                0              13h     10.130.0.60    cluster-797pp-master-1                      <none>           <none>
openshift-kube-controller-manager                  installer-9-cluster-797pp-master-2                               0/1     Completed                0              13h     10.128.0.29    cluster-797pp-master-2                      <none>           <none>
openshift-kube-controller-manager                  kube-controller-manager-cluster-797pp-master-0                   4/4     Running                  0              13h     10.0.0.10      cluster-797pp-master-0                      <none>           <none>
openshift-kube-controller-manager                  kube-controller-manager-cluster-797pp-master-1                   4/4     Running                  1 (140m ago)   13h     10.0.0.8       cluster-797pp-master-1                      <none>           <none>
openshift-kube-controller-manager                  kube-controller-manager-cluster-797pp-master-2                   4/4     Running                  0              13h     10.0.0.9       cluster-797pp-master-2                      <none>           <none>
openshift-kube-controller-manager                  kube-controller-manager-guard-cluster-797pp-master-0             1/1     Running                  0              13h     10.129.0.11    cluster-797pp-master-0                      <none>           <none>
openshift-kube-controller-manager                  kube-controller-manager-guard-cluster-797pp-master-1             1/1     Running                  0              13h     10.130.0.17    cluster-797pp-master-1                      <none>           <none>
openshift-kube-controller-manager                  kube-controller-manager-guard-cluster-797pp-master-2             1/1     Running                  0              13h     10.128.0.15    cluster-797pp-master-2                      <none>           <none>
openshift-kube-scheduler-operator                  openshift-kube-scheduler-operator-6d76b6d7d6-8srpn               1/1     Running                  0              13h     10.129.0.43    cluster-797pp-master-0                      <none>           <none>
openshift-kube-scheduler                           installer-8-cluster-797pp-master-1                               0/1     Completed                0              13h     10.130.0.53    cluster-797pp-master-1                      <none>           <none>
openshift-kube-scheduler                           installer-8-cluster-797pp-master-2                               0/1     Completed                0              13h     10.128.0.24    cluster-797pp-master-2                      <none>           <none>
openshift-kube-scheduler                           installer-9-cluster-797pp-master-0                               0/1     Completed                0              13h     10.129.0.53    cluster-797pp-master-0                      <none>           <none>
openshift-kube-scheduler                           installer-9-cluster-797pp-master-1                               0/1     Completed                0              13h     10.130.0.62    cluster-797pp-master-1                      <none>           <none>
openshift-kube-scheduler                           installer-9-cluster-797pp-master-2                               0/1     Completed                0              13h     10.128.0.25    cluster-797pp-master-2                      <none>           <none>
openshift-kube-scheduler                           openshift-kube-scheduler-cluster-797pp-master-0                  3/3     Running                  0              13h     10.0.0.10      cluster-797pp-master-0                      <none>           <none>
openshift-kube-scheduler                           openshift-kube-scheduler-cluster-797pp-master-1                  3/3     Running                  0              13h     10.0.0.8       cluster-797pp-master-1                      <none>           <none>
openshift-kube-scheduler                           openshift-kube-scheduler-cluster-797pp-master-2                  3/3     Running                  0              13h     10.0.0.9       cluster-797pp-master-2                      <none>           <none>
openshift-kube-scheduler                           openshift-kube-scheduler-guard-cluster-797pp-master-0            1/1     Running                  0              13h     10.129.0.9     cluster-797pp-master-0                      <none>           <none>
openshift-kube-scheduler                           openshift-kube-scheduler-guard-cluster-797pp-master-1            1/1     Running                  0              13h     10.130.0.14    cluster-797pp-master-1                      <none>           <none>
openshift-kube-scheduler                           openshift-kube-scheduler-guard-cluster-797pp-master-2            1/1     Running                  0              13h     10.128.0.14    cluster-797pp-master-2                      <none>           <none>
openshift-kube-scheduler                           revision-pruner-7-cluster-797pp-master-0                         0/1     Completed                0              13h     10.129.0.6     cluster-797pp-master-0                      <none>           <none>
openshift-kube-scheduler                           revision-pruner-7-cluster-797pp-master-1                         0/1     Completed                0              13h     10.130.0.6     cluster-797pp-master-1                      <none>           <none>
openshift-kube-scheduler                           revision-pruner-7-cluster-797pp-master-2                         0/1     Completed                0              13h     10.128.0.6     cluster-797pp-master-2                      <none>           <none>
openshift-kube-scheduler                           revision-pruner-8-cluster-797pp-master-0                         0/1     Completed                0              13h     10.129.0.46    cluster-797pp-master-0                      <none>           <none>
openshift-kube-scheduler                           revision-pruner-8-cluster-797pp-master-1                         0/1     Completed                0              13h     10.130.0.52    cluster-797pp-master-1                      <none>           <none>
openshift-kube-scheduler                           revision-pruner-8-cluster-797pp-master-2                         0/1     Completed                0              13h     10.128.0.19    cluster-797pp-master-2                      <none>           <none>
openshift-kube-scheduler                           revision-pruner-9-cluster-797pp-master-0                         0/1     Completed                0              13h     10.129.0.51    cluster-797pp-master-0                      <none>           <none>
openshift-kube-scheduler                           revision-pruner-9-cluster-797pp-master-1                         0/1     Completed                0              13h     10.130.0.58    cluster-797pp-master-1                      <none>           <none>
openshift-kube-scheduler                           revision-pruner-9-cluster-797pp-master-2                         0/1     Completed                0              13h     10.128.0.26    cluster-797pp-master-2                      <none>           <none>
openshift-kube-storage-version-migrator-operator   kube-storage-version-migrator-operator-5df95dd98c-5m4mc          1/1     Running                  0              13h     10.130.0.35    cluster-797pp-master-1                      <none>           <none>
openshift-kube-storage-version-migrator            migrator-6d97585567-96j5x                                        1/1     Running                  0              13h     10.129.0.23    cluster-797pp-master-0                      <none>           <none>
openshift-machine-api                              cluster-autoscaler-operator-dc8fc5557-f5gwz                      2/2     Running                  0              13h     10.130.0.32    cluster-797pp-master-1                      <none>           <none>
openshift-machine-api                              control-plane-machine-set-operator-5cfd4c579b-5wrfh              1/1     Running                  0              13h     10.130.0.42    cluster-797pp-master-1                      <none>           <none>
openshift-machine-api                              machine-api-controllers-544555bbb4-v4xxr                         7/7     Running                  0              13h     10.129.0.27    cluster-797pp-master-0                      <none>           <none>
openshift-machine-api                              machine-api-operator-58cb7f5c9c-nwhcz                            2/2     Running                  0              13h     10.130.0.23    cluster-797pp-master-1                      <none>           <none>
openshift-machine-config-operator                  kube-rbac-proxy-crio-cluster-797pp-master-0                      1/1     Running                  4              14h     10.0.0.10      cluster-797pp-master-0                      <none>           <none>
openshift-machine-config-operator                  kube-rbac-proxy-crio-cluster-797pp-master-1                      1/1     Running                  3              14h     10.0.0.8       cluster-797pp-master-1                      <none>           <none>
openshift-machine-config-operator                  kube-rbac-proxy-crio-cluster-797pp-master-2                      1/1     Running                  4              14h     10.0.0.9       cluster-797pp-master-2                      <none>           <none>
openshift-machine-config-operator                  kube-rbac-proxy-crio-cluster-797pp-worker-canadacentral1-dnw2p   1/1     Running                  1              14h     10.0.2.4       cluster-797pp-worker-canadacentral1-dnw2p   <none>           <none>
openshift-machine-config-operator                  kube-rbac-proxy-crio-cluster-797pp-worker-canadacentral2-5qbbl   1/1     Running                  1              14h     10.0.2.6       cluster-797pp-worker-canadacentral2-5qbbl   <none>           <none>
openshift-machine-config-operator                  kube-rbac-proxy-crio-cluster-797pp-worker-canadacentral3-sqvbs   1/1     Running                  1              14h     10.0.2.5       cluster-797pp-worker-canadacentral3-sqvbs   <none>           <none>
openshift-machine-config-operator                  machine-config-controller-d54fc85bb-96fs7                        2/2     Running                  0              13h     10.129.0.26    cluster-797pp-master-0                      <none>           <none>
openshift-machine-config-operator                  machine-config-daemon-c4h72                                      2/2     Running                  2              14h     10.0.0.8       cluster-797pp-master-1                      <none>           <none>
openshift-machine-config-operator                  machine-config-daemon-cxqps                                      2/2     Running                  2              14h     10.0.0.9       cluster-797pp-master-2                      <none>           <none>
openshift-machine-config-operator                  machine-config-daemon-f949g                                      2/2     Running                  2              14h     10.0.0.10      cluster-797pp-master-0                      <none>           <none>
openshift-machine-config-operator                  machine-config-daemon-g4cv7                                      2/2     Running                  2              14h     10.0.2.4       cluster-797pp-worker-canadacentral1-dnw2p   <none>           <none>
openshift-machine-config-operator                  machine-config-daemon-mzzrx                                      2/2     Running                  2              14h     10.0.2.6       cluster-797pp-worker-canadacentral2-5qbbl   <none>           <none>
openshift-machine-config-operator                  machine-config-daemon-z77vl                                      2/2     Running                  2              14h     10.0.2.5       cluster-797pp-worker-canadacentral3-sqvbs   <none>           <none>
openshift-machine-config-operator                  machine-config-operator-59ccd87d7b-dghng                         2/2     Running                  0              13h     10.130.0.47    cluster-797pp-master-1                      <none>           <none>
openshift-machine-config-operator                  machine-config-server-96wvx                                      1/1     Running                  1              14h     10.0.0.9       cluster-797pp-master-2                      <none>           <none>
openshift-machine-config-operator                  machine-config-server-lhpwm                                      1/1     Running                  1              14h     10.0.0.8       cluster-797pp-master-1                      <none>           <none>
openshift-machine-config-operator                  machine-config-server-mcg49                                      1/1     Running                  1              14h     10.0.0.10      cluster-797pp-master-0                      <none>           <none>
openshift-managed-upgrade-operator                 managed-upgrade-operator-5cccc675c6-f79db                        1/1     Running                  0              13h     10.129.0.30    cluster-797pp-master-0                      <none>           <none>
openshift-marketplace                              certified-operators-xz4v4                                        1/1     Running                  0              164m    10.128.0.255   cluster-797pp-master-2                      <none>           <none>
openshift-marketplace                              community-operators-22z78                                        1/1     Running                  0              33m     10.128.1.42    cluster-797pp-master-2                      <none>           <none>
openshift-marketplace                              marketplace-operator-6c6dccc45d-mzqkk                            1/1     Running                  0              13h     10.129.0.41    cluster-797pp-master-0                      <none>           <none>
openshift-marketplace                              redhat-marketplace-n8ghg                                         1/1     Running                  0              12h     10.128.0.57    cluster-797pp-master-2                      <none>           <none>
openshift-marketplace                              redhat-operators-k6sfz                                           1/1     Running                  0              13h     10.129.0.25    cluster-797pp-master-0                      <none>           <none>
openshift-monitoring                               alertmanager-main-0                                              6/6     Running                  0              13h     10.128.2.14    cluster-797pp-worker-canadacentral2-5qbbl   <none>           <none>
openshift-monitoring                               alertmanager-main-1                                              6/6     Running                  0              13h     10.129.2.16    cluster-797pp-worker-canadacentral1-dnw2p   <none>           <none>
openshift-monitoring                               cluster-monitoring-operator-569b7df5bb-9gv79                     1/1     Running                  0              13h     10.129.0.42    cluster-797pp-master-0                      <none>           <none>
openshift-monitoring                               kube-state-metrics-5f57758884-sgl29                              3/3     Running                  0              13h     10.129.2.8     cluster-797pp-worker-canadacentral1-dnw2p   <none>           <none>
openshift-monitoring                               monitoring-plugin-65f465bc9d-d5vsm                               1/1     Running                  0              13h     10.129.2.7     cluster-797pp-worker-canadacentral1-dnw2p   <none>           <none>
openshift-monitoring                               monitoring-plugin-65f465bc9d-lld24                               1/1     Running                  0              13h     10.128.2.6     cluster-797pp-worker-canadacentral2-5qbbl   <none>           <none>
openshift-monitoring                               node-exporter-9c5wt                                              2/2     Running                  2              14h     10.0.0.9       cluster-797pp-master-2                      <none>           <none>
openshift-monitoring                               node-exporter-f2cnr                                              2/2     Running                  2              14h     10.0.2.4       cluster-797pp-worker-canadacentral1-dnw2p   <none>           <none>
openshift-monitoring                               node-exporter-p5qnm                                              2/2     Running                  2              14h     10.0.0.8       cluster-797pp-master-1                      <none>           <none>
openshift-monitoring                               node-exporter-q4q9d                                              2/2     Running                  2              14h     10.0.2.5       cluster-797pp-worker-canadacentral3-sqvbs   <none>           <none>
openshift-monitoring                               node-exporter-q57j9                                              2/2     Running                  2              14h     10.0.0.10      cluster-797pp-master-0                      <none>           <none>
openshift-monitoring                               node-exporter-slbw8                                              2/2     Running                  2              14h     10.0.2.6       cluster-797pp-worker-canadacentral2-5qbbl   <none>           <none>
openshift-monitoring                               openshift-state-metrics-7c9fd6666c-zb8rn                         3/3     Running                  0              13h     10.129.2.15    cluster-797pp-worker-canadacentral1-dnw2p   <none>           <none>
openshift-monitoring                               prometheus-adapter-5dd56d6c87-dlsvw                              1/1     Running                  0              13h     10.129.2.13    cluster-797pp-worker-canadacentral1-dnw2p   <none>           <none>
openshift-monitoring                               prometheus-adapter-5dd56d6c87-xzpw7                              1/1     Running                  0              13h     10.128.2.9     cluster-797pp-worker-canadacentral2-5qbbl   <none>           <none>
openshift-monitoring                               prometheus-k8s-0                                                 6/6     Running                  0              13h     10.128.2.12    cluster-797pp-worker-canadacentral2-5qbbl   <none>           <none>
openshift-monitoring                               prometheus-k8s-1                                                 6/6     Running                  0              13h     10.129.2.17    cluster-797pp-worker-canadacentral1-dnw2p   <none>           <none>
openshift-monitoring                               prometheus-operator-57bccc7c54-llb6c                             2/2     Running                  0              13h     10.129.0.34    cluster-797pp-master-0                      <none>           <none>
openshift-monitoring                               prometheus-operator-admission-webhook-696d46d5b5-ftbws           1/1     Running                  0              13h     10.128.2.11    cluster-797pp-worker-canadacentral2-5qbbl   <none>           <none>
openshift-monitoring                               prometheus-operator-admission-webhook-696d46d5b5-fzsj5           1/1     Running                  0              13h     10.129.2.5     cluster-797pp-worker-canadacentral1-dnw2p   <none>           <none>
openshift-monitoring                               thanos-querier-b9647b6f8-4p9hm                                   6/6     Running                  0              13h     10.129.2.11    cluster-797pp-worker-canadacentral1-dnw2p   <none>           <none>
openshift-monitoring                               thanos-querier-b9647b6f8-6nrmk                                   6/6     Running                  0              13h     10.128.2.15    cluster-797pp-worker-canadacentral2-5qbbl   <none>           <none>
openshift-multus                                   multus-5gd98                                                     1/1     Running                  2              14h     10.0.0.10      cluster-797pp-master-0                      <none>           <none>
openshift-multus                                   multus-79mjb                                                     1/1     Running                  2              14h     10.0.2.6       cluster-797pp-worker-canadacentral2-5qbbl   <none>           <none>
openshift-multus                                   multus-additional-cni-plugins-bqxg6                              1/1     Running                  1              14h     10.0.0.8       cluster-797pp-master-1                      <none>           <none>
openshift-multus                                   multus-additional-cni-plugins-d29fm                              1/1     Running                  1              14h     10.0.2.5       cluster-797pp-worker-canadacentral3-sqvbs   <none>           <none>
openshift-multus                                   multus-additional-cni-plugins-jkc6w                              1/1     Running                  1              14h     10.0.0.10      cluster-797pp-master-0                      <none>           <none>
openshift-multus                                   multus-additional-cni-plugins-kd562                              1/1     Running                  1              14h     10.0.0.9       cluster-797pp-master-2                      <none>           <none>
openshift-multus                                   multus-additional-cni-plugins-q87z9                              1/1     Running                  1              14h     10.0.2.6       cluster-797pp-worker-canadacentral2-5qbbl   <none>           <none>
openshift-multus                                   multus-additional-cni-plugins-xmwrp                              1/1     Running                  1              14h     10.0.2.4       cluster-797pp-worker-canadacentral1-dnw2p   <none>           <none>
openshift-multus                                   multus-admission-controller-5ff5f56db5-5fkv8                     2/2     Running                  0              13h     10.129.0.37    cluster-797pp-master-0                      <none>           <none>
openshift-multus                                   multus-admission-controller-5ff5f56db5-wjkjs                     2/2     Running                  0              13h     10.129.0.36    cluster-797pp-master-0                      <none>           <none>
openshift-multus                                   multus-btpjh                                                     1/1     Running                  2              14h     10.0.0.8       cluster-797pp-master-1                      <none>           <none>
openshift-multus                                   multus-gpk8l                                                     1/1     Running                  2              14h     10.0.0.9       cluster-797pp-master-2                      <none>           <none>
openshift-multus                                   multus-nx7vw                                                     1/1     Running                  1              14h     10.0.2.4       cluster-797pp-worker-canadacentral1-dnw2p   <none>           <none>
openshift-multus                                   multus-qbrlv                                                     1/1     Running                  2              14h     10.0.2.5       cluster-797pp-worker-canadacentral3-sqvbs   <none>           <none>
openshift-multus                                   network-metrics-daemon-487jg                                     2/2     Running                  2              14h     10.130.0.3     cluster-797pp-master-1                      <none>           <none>
openshift-multus                                   network-metrics-daemon-55q5k                                     2/2     Running                  2              14h     10.129.0.4     cluster-797pp-master-0                      <none>           <none>
openshift-multus                                   network-metrics-daemon-bqrcd                                     2/2     Running                  2              14h     10.128.0.4     cluster-797pp-master-2                      <none>           <none>
openshift-multus                                   network-metrics-daemon-ksf7f                                     2/2     Running                  2              14h     10.129.2.3     cluster-797pp-worker-canadacentral1-dnw2p   <none>           <none>
openshift-multus                                   network-metrics-daemon-pb7bb                                     2/2     Running                  2              14h     10.128.2.4     cluster-797pp-worker-canadacentral2-5qbbl   <none>           <none>
openshift-multus                                   network-metrics-daemon-z7htx                                     2/2     Running                  2              14h     10.131.0.3     cluster-797pp-worker-canadacentral3-sqvbs   <none>           <none>
openshift-network-diagnostics                      network-check-source-7c6cdbc8f5-hh2hw                            1/1     Running                  0              13h     10.128.2.7     cluster-797pp-worker-canadacentral2-5qbbl   <none>           <none>
openshift-network-diagnostics                      network-check-target-9jz6s                                       1/1     Running                  1              14h     10.128.0.3     cluster-797pp-master-2                      <none>           <none>
openshift-network-diagnostics                      network-check-target-czn27                                       1/1     Running                  1              14h     10.130.0.4     cluster-797pp-master-1                      <none>           <none>
openshift-network-diagnostics                      network-check-target-fr9r7                                       1/1     Running                  1              14h     10.128.2.3     cluster-797pp-worker-canadacentral2-5qbbl   <none>           <none>
openshift-network-diagnostics                      network-check-target-lj7c9                                       1/1     Running                  1              14h     10.131.0.4     cluster-797pp-worker-canadacentral3-sqvbs   <none>           <none>
openshift-network-diagnostics                      network-check-target-t2dlp                                       1/1     Running                  1              14h     10.129.0.3     cluster-797pp-master-0                      <none>           <none>
openshift-network-diagnostics                      network-check-target-zpk2q                                       1/1     Running                  1              14h     10.129.2.4     cluster-797pp-worker-canadacentral1-dnw2p   <none>           <none>
openshift-network-node-identity                    network-node-identity-4jfms                                      2/2     Running                  2              14h     10.0.0.8       cluster-797pp-master-1                      <none>           <none>
openshift-network-node-identity                    network-node-identity-frj6g                                      2/2     Running                  2              14h     10.0.0.9       cluster-797pp-master-2                      <none>           <none>
openshift-network-node-identity                    network-node-identity-md2lg                                      2/2     Running                  4              14h     10.0.0.10      cluster-797pp-master-0                      <none>           <none>
openshift-network-operator                         network-operator-77c84c6494-ktbfk                                1/1     Running                  0              13h     10.0.0.10      cluster-797pp-master-0                      <none>           <none>
openshift-oauth-apiserver                          apiserver-c86b7c8f7-bxl8f                                        1/1     Running                  0              13h     10.128.0.12    cluster-797pp-master-2                      <none>           <none>
openshift-oauth-apiserver                          apiserver-c86b7c8f7-l8pgd                                        1/1     Running                  0              13h     10.130.0.9     cluster-797pp-master-1                      <none>           <none>
openshift-oauth-apiserver                          apiserver-c86b7c8f7-vkb5l                                        1/1     Running                  0              13h     10.129.0.16    cluster-797pp-master-0                      <none>           <none>
openshift-operator-lifecycle-manager               catalog-operator-6c9769bd4f-hxrqj                                1/1     Running                  0              13h     10.130.0.31    cluster-797pp-master-1                      <none>           <none>
openshift-operator-lifecycle-manager               collect-profiles-29130045-6ntf7                                  0/1     Completed                0              38m     10.128.2.71    cluster-797pp-worker-canadacentral2-5qbbl   <none>           <none>
openshift-operator-lifecycle-manager               collect-profiles-29130060-n55k6                                  0/1     Completed                0              23m     10.128.2.72    cluster-797pp-worker-canadacentral2-5qbbl   <none>           <none>
openshift-operator-lifecycle-manager               collect-profiles-29130075-fkhg7                                  0/1     Completed                0              8m39s   10.128.2.73    cluster-797pp-worker-canadacentral2-5qbbl   <none>           <none>
openshift-operator-lifecycle-manager               olm-operator-5d8456cd6d-kbf7b                                    1/1     Running                  0              13h     10.130.0.40    cluster-797pp-master-1                      <none>           <none>
openshift-operator-lifecycle-manager               package-server-manager-7f954c99f5-kqbbs                          2/2     Running                  0              13h     10.130.0.26    cluster-797pp-master-1                      <none>           <none>
openshift-operator-lifecycle-manager               packageserver-849f598bff-p44l8                                   1/1     Running                  0              13h     10.130.0.28    cluster-797pp-master-1                      <none>           <none>
openshift-operator-lifecycle-manager               packageserver-849f598bff-r2kvt                                   1/1     Running                  0              13h     10.129.0.24    cluster-797pp-master-0                      <none>           <none>
openshift-ovn-kubernetes                           ovnkube-control-plane-6ddc6b7c8b-2dhqf                           2/2     Running                  0              13h     10.0.0.10      cluster-797pp-master-0                      <none>           <none>
openshift-ovn-kubernetes                           ovnkube-control-plane-6ddc6b7c8b-t5cnv                           2/2     Running                  0              13h     10.0.0.8       cluster-797pp-master-1                      <none>           <none>
openshift-ovn-kubernetes                           ovnkube-node-77xqg                                               9/9     Running                  9              14h     10.0.0.9       cluster-797pp-master-2                      <none>           <none>
openshift-ovn-kubernetes                           ovnkube-node-9gn7z                                               9/9     Running                  9              14h     10.0.0.10      cluster-797pp-master-0                      <none>           <none>
openshift-ovn-kubernetes                           ovnkube-node-9rxbz                                               9/9     Running                  10             14h     10.0.2.4       cluster-797pp-worker-canadacentral1-dnw2p   <none>           <none>
openshift-ovn-kubernetes                           ovnkube-node-krmcg                                               9/9     Running                  9              14h     10.0.2.6       cluster-797pp-worker-canadacentral2-5qbbl   <none>           <none>
openshift-ovn-kubernetes                           ovnkube-node-mwgpm                                               9/9     Running                  9              14h     10.0.0.8       cluster-797pp-master-1                      <none>           <none>
openshift-ovn-kubernetes                           ovnkube-node-w26hd                                               9/9     Running                  9              14h     10.0.2.5       cluster-797pp-worker-canadacentral3-sqvbs   <none>           <none>
openshift-route-controller-manager                 route-controller-manager-9f7f7c868-b8kxc                         1/1     Running                  0              13h     10.129.0.19    cluster-797pp-master-0                      <none>           <none>
openshift-route-controller-manager                 route-controller-manager-9f7f7c868-jx5tt                         1/1     Running                  0              13h     10.130.0.12    cluster-797pp-master-1                      <none>           <none>
openshift-route-controller-manager                 route-controller-manager-9f7f7c868-pl6r2                         1/1     Running                  0              13h     10.128.0.13    cluster-797pp-master-2                      <none>           <none>
openshift-service-ca-operator                      service-ca-operator-fcc986794-sdwgc                              1/1     Running                  0              13h     10.129.0.39    cluster-797pp-master-0                      <none>           <none>
openshift-service-ca                               service-ca-6b859dc56d-hbskv                                      1/1     Running                  0              13h     10.129.0.38    cluster-797pp-master-0                      <none>           <none>
```