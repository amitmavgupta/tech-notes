# AKS Networking Models and Considerations

 On 31 March 2028, kubenet networking for Azure Kubernetes Service (AKS) will be retired.****

## Overview

Azure Kubernetes Service (AKS) supports three networking models for pod-to-pod and pod-to-external communication. Each model has different IP address management strategies, scalability characteristics, and feature support. This guide helps you understand each model and choose the right one for your needs.

---

## 1. Kubenet Networking

### What is Kubenet?

AKS clusters use kubenet and create an Azure virtual network and subnet for you by default. With kubenet, nodes get an IP address from the Azure virtual network subnet.

- Pods receive an IP address from a logically different address space to the Azure virtual network subnet of the nodes.
- Network address translation (NAT) is configured so pods can reach resources on the Azure virtual network.
- The source IP address of the traffic is NAT'd to the node's primary IP address.
- This approach greatly reduces the number of IP addresses you need to reserve in your network space for pods to use.

### How It Works

With *kubenet*, only the nodes receive an IP address in the virtual network subnet. Pods can't communicate directly with each other.

- Instead, User Defined Routing (UDR) and IP forwarding handle connectivity between pods across nodes.
- UDRs and IP forwarding configuration is created and maintained by the AKS service by default, but you can [bring your own route table for custom route management](https://learn.microsoft.com/en-us/azure/aks/configure-kubenet#bring-your-own-subnet-and-route-table-with-kubenet) if you want.
- You can also deploy pods behind a service that receives an assigned IP address and load balances traffic for the application.
- Azure supports a maximum of *400* routes in a UDR, so you can't have an AKS cluster larger than 400 nodes.

### Limitations & Considerations for Kubenet

- An additional hop is required in the design of kubenet, which adds minor latency to pod communication.
- Route tables and user-defined routes are required for using kubenet, which adds complexity to operations.
- Direct pod addressing isn't supported for kubenet due to kubenet design.
- Unlike Azure CNI clusters, multiple kubenet clusters can't share a subnet.
- AKS doesn't apply Network Security Groups (NSGs) to its subnet and doesn't modify any of the NSGs associated with that subnet. If you provide your subnet and add NSGs associated with that subnet, you must ensure the security rules in the NSGs allow traffic between the node and pod CIDR.
- Features **not supported on kubenet** include:
  - [Azure network policies](https://learn.microsoft.com/en-us/azure/aks/use-network-policies#create-an-aks-cluster-and-enable-network-policy)
  - [Windows node pools](https://learn.microsoft.com/en-us/azure/aks/windows-faq)
  - [Virtual nodes add-on](https://learn.microsoft.com/en-us/azure/aks/virtual-nodes#network-requirements)

### Dual-Stack Support for Kubenet

You can deploy your AKS clusters in a dual-stack mode when using [kubenet](https://learn.microsoft.com/en-us/azure/aks/configure-kubenet) networking and a dual-stack Azure virtual network.

- In this configuration, nodes receive both an IPv4 and IPv6 address from the Azure virtual network subnet.
- Pods receive both an IPv4 and IPv6 address from a logically different address space to the Azure virtual network subnet of the nodes.
- Network address translation (NAT) is configured so that the pods can reach resources on the Azure virtual network.
- The source IP address of the traffic is NAT'd to the node's primary IP address of the same family (IPv4 to IPv4 and IPv6 to IPv6).

#### Limitations for Dual-Stack with Kubenet

- Azure route tables have a **hard limit of 400 routes per table**.
  - Each node in a dual-stack cluster requires two routes, one for each IP address family, so **dual-stack clusters are limited to 200 nodes**.
- In Azure Linux node pools, service objects are only supported with `externalTrafficPolicy: Local`.
- Dual-stack networking is required for the Azure virtual network and the pod CIDR.
  - Single stack IPv6-only isn't supported for node or pod IP addresses. Services can be provisioned on IPv4 or IPv6.
- The following features are **not supported on dual-stack kubenet**:
  - Azure network policies
  - Calico network policies
  - NAT Gateway
  - Virtual nodes add-on
  - Windows node pools

---

## 2. Azure CNI Networking

### What is Azure CNI?

With Azure Container Networking Interface (CNI), every pod gets an IP address from the subnet and can be accessed directly.

- These IP addresses must be planned and unique across your network space.
- Each node has a configuration parameter for the maximum number of pods it supports.
- The equivalent number of IP addresses per node is then reserved up front for that node.
- This approach requires more planning and often leads to IP address exhaustion or the need to rebuild clusters in a larger subnet as your application demands grow.
- You can configure the maximum pods deployable to a node at cluster creation time or when creating new node pools. If you don't specify `maxPods` when creating new node pools, you receive a default value of 300 for Azure CNI.

### Cilium Integration with Azure CNI

"Azure CNI" is the historical and current default option when you create AKS clusters. For installing Cilium in such a cluster, it was possible to use either:

- **Azure IPAM integration** (now dubbed "Legacy Azure IPAM"): Under the hood, this removes Azure CNI and replaces it with Cilium as the only CNI on the nodes. It should be avoided because new nodes will have pods scheduled on them before Cilium comes in to remove Azure CNI and replace it. The only advantage of Azure IPAM is that it has deeper integration capabilities with the Azure API, and a couple of advanced Cilium users have built tooling around it.

---

## 3. Azure CNI Overlay Networking

### What is Azure CNI Overlay?

With Azure CNI Overlay, the cluster nodes are deployed into an Azure Virtual Network (VNet) subnet.

- Pods are assigned IP addresses from a private CIDR logically different from the VNet hosting the nodes.
- Pod and node traffic within the cluster use an Overlay network. Network Address Translation (NAT) uses the node's IP address to reach resources outside the cluster.
- This solution saves a significant amount of VNet IP addresses and enables you to scale your cluster to large sizes.
- An extra advantage is that you can reuse the private CIDR in different AKS clusters, which extends the IP space available for containerized applications in Azure Kubernetes Service (AKS).

### How Overlay Networking Works

- In Overlay networking, only the Kubernetes cluster nodes are assigned IPs from a subnet. Pods receive IPs from a private CIDR provided at the time of cluster creation. Each node is assigned a `/24` address space carved out from the same CIDR. Extra nodes created when you scale out a cluster automatically receive `/24` address spaces from the same CIDR. Azure CNI assigns IPs to pods from this `/24` space.
- A separate routing domain is created in the Azure Networking stack for the pod's private CIDR space, which creates an Overlay network for direct communication between pods.
- There's no need to provision custom routes on the cluster subnet or use an encapsulation method to tunnel traffic between pod, which provides connectivity performance between pods on par with VMs in a VNet.
- Communication with endpoints outside the cluster, such as on-premises and peered VNets, happens using the node IP through NAT. Azure CNI translates the source IP (Overlay IP of the pod) of the traffic to the primary IP address of the VM, which enables the Azure Networking stack to route the traffic to the destination. Endpoints outside the cluster can't connect to a pod directly. You have to publish the pod's application as a Kubernetes Load Balancer service to make it reachable on the VNet.
- You can provide outbound (egress) connectivity to the internet for Overlay pods using a Standard SKU Load Balancer or managed NAT Gateway. You can also control egress traffic by directing it to a firewall using User Defined Routes on the cluster subnet.
- You can configure ingress connectivity to the cluster using an ingress controller, such as Nginx or HTTP application routing.

### Limitations with Azure CNI Overlay

- You can't use Application Gateway as an Ingress Controller (AGIC) for an Overlay cluster.
- Virtual Machine Availability Sets (VMAS) aren't supported for Overlay.
- Dual stack networking isn't supported in Overlay.

---

## Pod Scaling and Limits

### Maximum Pods Per Node

The maximum number of pods per node in an AKS cluster is 250. The *default* maximum number of pods per node varies between *kubenet* and *Azure CNI* networking, and the method of cluster deployment.

| **Deployment Method** | **Kubenet Default** | **Azure CNI Default** | **Configurable at Deployment** |
| --- | --- | --- | --- |
| Azure CLI | 110 | 30 | Yes (up to 250) |
| Resource Manager template | 110 | 30 | Yes (up to 250) |
| Portal | 110 | 110 (configurable in the Node Pools tab) | Yes (up to 250) |

### Configuring Maximum Pods for New Clusters

- You're able to configure the maximum number of pods per node at cluster deployment time or as you add new node pools. You can set the maximum pods per node value as high as 250.
- If you don't specify `maxPods` when creating new node pools, you receive a default value of 30 for Azure CNI.
- A minimum value for maximum pods per node is enforced to guarantee space for system pods critical to cluster health. The minimum value that can be set for maximum pods per node is 10 if and only if the configuration of each node pool has space for a minimum of 30 pods. For example, setting the maximum number of pods per node to a minimum of 10 requires each individual node pool to have a minimum of 3 nodes. This requirement applies for each new node pool created as well, so if 10 is defined as maximum pods per node each subsequent node pool added must have at least 3 nodes.

| **Networking** | **Minimum** | **Maximum** |
| --- | --- | --- |
| Azure CNI | 10 | 250 |
| Kubenet | 10 | 250 |

---

## Network Models Comparison

### IP Address Efficiency

The following basic calculations compare the difference in network models using a simple */24* IP address range:

- **Kubenet**: Can support up to *251* nodes in the cluster. Each Azure virtual network subnet reserves the first three IP addresses for management operations. This node count can support up to *27,610* pods, with a default maximum of 110 pods per node.
- **Azure CNI**: Can only support a maximum of *eight* nodes in the cluster. This node count can only support up to *240* pods, with a default maximum of 30 pods per node.
- **Azure CNI Overlay**: Nodes are assigned from the VNet subnet, but pods use a separate private CIDR. This allows for much better IP address utilization and larger cluster scaling while reusing the same pod CIDR across multiple clusters.

### Capability Comparison

| **Capability** | **Kubenet** | **Azure CNI** | **Azure CNI Overlay** |
| --- | --- | --- | --- |
| Deploy cluster in existing VNet | Supported (UDRs manually applied) | Supported | Supported |
| Pod-pod connectivity | Supported | Supported | Supported |
| Pod-VM connectivity (same VNet) | Works when initiated by pod | Works both ways | Works both ways (via NAT) |
| Pod-VM connectivity (peered VNet) | Works when initiated by pod | Works both ways | Works both ways (via NAT) |
| On-premises access via VPN/Express Route | Works when initiated by pod | Works both ways | Works both ways (via NAT) |
| Access to resources secured by service endpoints | Supported | Supported | Supported |
| Expose services (LoadBalancer, App Gateway, Ingress) | Supported | Supported | Supported (no AGIC) |
| Default Azure DNS and Private Zones | Supported | Supported | Supported |
| Support for Windows node pools | Not Supported | Supported | Not documented |
| Virtual nodes add-on | Not Supported | Supported | Not Supported |
| Multiple clusters sharing one subnet | Not Supported | Supported | Supported (different pod CIDRs) |
| Network policies supported | Calico only | Calico and Azure Network Policies | Calico and Azure Network Policies |
| Application Gateway as Ingress (AGIC) | Supported | Supported | Not Supported |
| Dual-stack networking | Supported (limited to 200 nodes) | Supported | Not Supported |

---

## Choosing the Right Networking Model

### Use **Kubenet** when:

- You have limited IP address space.
- Most of the pod communication is within the cluster.
- You don't need advanced AKS features, such as virtual nodes or Azure Network Policy.
 **Note:** Kubenet is being retired on 31 March 2028. Plan migrations to Azure CNI or Azure CNI Overlay.- 

### Use **Azure CNI** when:

- You have available IP address space.
- Most of the pod communication is to resources outside of the cluster.
- You don't want to manage user-defined routes for pod connectivity.
- You need AKS advanced features, such as virtual nodes or Azure Network Policy.
- You need Application Gateway as an Ingress Controller (AGIC).
- You require dual-stack IPv4/IPv6 networking.

### Use **Azure CNI Overlay** when:

- You want to maximize IP address efficiency while maintaining Azure VNet integration.
- You need to scale clusters to large sizes with many nodes and pods.
- You want to reuse the same pod CIDR across multiple AKS clusters.
- You don't need AGIC or Virtual Machine Availability Sets (VMAS).
- You prefer simplified networking management without UDR complexity.

---

## Sample API Call: Kubenet Route Table Management

```json
{
    "authorization": {
        "action": "Microsoft.Network/routeTables/write",
        "scope": "/subscriptions/#####################################/resourceGroups/mc_nwpluginkubenet_nwpluginkubenet_eastus/providers/Microsoft.Network/routeTables/aks-agentpool-48350840-routetable"
    },
    "caller": "#####################################",
    "channels": "Operation",
    "claims": {
        "aud": "https://management.core.windows.net/",
        "iss": "https://sts.windows.net/#####################################/",
        "iat": "1692158288",
        "nbf": "1692158288",
        "exp": "1692244988",
        "aio": "#####################################",
        "appid": "#####################################",
        "appidacr": "2",
        "http://schemas.microsoft.com/identity/claims/identityprovider": "https://sts.windows.net/#####################################/",
        "idtyp": "app",
        "http://schemas.microsoft.com/identity/claims/objectidentifier": "#####################################",
        "rh": "0.AVEAddpcYt1iDkelVHMTh3_wPEZIf3kAutdPukPawfj2MBNRAAA.",
        "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier": "#####################################",
        "http://schemas.microsoft.com/identity/claims/tenantid": "#####################################",
        "uti": "cRZ8-NDqNECeq2PmIKW8Ag",
        "ver": "1.0",
        "xms_mirid": "/subscriptions/#####################################/resourcegroups/nwpluginkubenet/providers/Microsoft.ContainerService/managedClusters/nwpluginkubenet",
        "xms_tcdt": "1589910443"
    },
    "correlationId": "#####################################",
    "description": "",
    "eventDataId": "#####################################",
    "eventName": {
        "value": "BeginRequest",
        "localizedValue": "Begin request"
    },
    "category": {
        "value": "Administrative",
        "localizedValue": "Administrative"
    },
    "eventTimestamp": "2023-08-16T04:04:07.5557146Z",
    "id": "/subscriptions/#####################################/resourceGroups/mc_nwpluginkubenet_nwpluginkubenet_eastus/providers/Microsoft.Network/routeTables/aks-agentpool-48350840-routetable/events/#####################################/ticks/#####################################",
    "level": "Informational",
    "operationId": "#####################################",
    "operationName": {
        "value": "Microsoft.Network/routeTables/write",
        "localizedValue": "Create or Update Route Table"
    },
    "resourceGroupName": "mc_nwpluginkubenet_nwpluginkubenet_eastus",
    "resourceProviderName": {
        "value": "Microsoft.Network",
        "localizedValue": "Microsoft.Network"
    },
    "resourceType": {
        "value": "Microsoft.Network/routeTables",
        "localizedValue": "Microsoft.Network/routeTables"
    },
    "resourceId": "/subscriptions/#####################################/resourceGroups/mc_nwpluginkubenet_nwpluginkubenet_eastus/providers/Microsoft.Network/routeTables/aks-agentpool-48350840-routetable",
    "status": {
        "value": "Started",
        "localizedValue": "Started"
    },
    "subStatus": {
        "value": "",
        "localizedValue": ""
    },
    "submissionTimestamp": "2023-08-16T04:07:23Z",
    "subscriptionId": "#####################################",
    "tenantId": "#####################################",
    "properties": {
        "requestbody": "{\"id\":\"/subscriptions/#####################################/resourceGroups/MC_nwpluginkubenet_nwpluginkubenet_eastus/providers/Microsoft.Network/routeTables/aks-agentpool-48350840-routetable\",\"location\":\"eastus\",\"properties\":{\"disableBgpRoutePropagation\":false,\"routes\":[{\"name\":\"aks-nodepool1-12355964-vmss000001____102441024\",\"properties\":{\"addressPrefix\":\"10.244.1.0/24\",\"nextHopIpAddress\":\"192.168.1.5\",\"nextHopType\":\"VirtualAppliance\"}},{\"name\":\"aks-nodepool1-12355964-vmss000000____102440024\",\"properties\":{\"addressPrefix\":\"10.244.0.0/24\",\"nextHopIpAddress\":\"192.168.1.4\",\"nextHopType\":\"VirtualAppliance\"}}]},\"tags\":{}}",
        "eventCategory": "Administrative",
        "entity": "/subscriptions/#####################################/resourceGroups/mc_nwpluginkubenet_nwpluginkubenet_eastus/providers/Microsoft.Network/routeTables/aks-agentpool-48350840-routetable",
        "message": "Microsoft.Network/routeTables/write",
        "hierarchy": "625cda75-62dd-470e-a554-7313877ff03c/cilium/#####################################"
    },
    "relatedEvents": []
}
```
