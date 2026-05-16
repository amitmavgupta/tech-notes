# AKS CNI Configurations Reference

## Overview

This document provides the default CNI configurations for various networking modes in AKS clusters. For each mode, we show both the default configuration and the configuration after upgrading to Cilium Enterprise Edition (CEE).

---

## 1. Azure CNI (Default) - Deprecated

The traditional Azure CNI configuration uses Azure-native IPAM and port mapping.

### Default Configuration

```json
{
   "cniVersion":"0.3.0",
   "name":"azure",
   "plugins":[
      {
         "type":"azure-vnet",
         "mode":"transparent",
         "ipsToRouteViaHost":["169.254.20.10"],
         "ipam":{
            "type":"azure-vnet-ipam"
         }
      },
      {
         "type":"portmap",
         "capabilities":{
            "portMappings":true
         },
         "snat":true
      }
   ]
}
```

### After Upgrade to Cilium Enterprise Edition (CEE)

```json
{
  "cniVersion": "0.3.1",
  "name": "cilium",
  "type": "cilium-cni",
  "enable-debug": false,
  "log-file": "/var/run/cilium/cilium-cni.log"
}
```

### Notes

- The local listen IP address for NodeLocal DNSCache can be any IP in the `169.254.20.0/16` space or any other IP address that is guaranteed not to collide with existing IPs.
- The first 10 IPs in that space are reserved. Across deployments, `169.254.20.10` is commonly used as the DNS IP.

---

## 2. Azure CNI Overlay

Azure CNI Overlay mode uses a private CIDR for pods while nodes remain in the VNet subnet.

### Default Configuration

```json
{
   "cniVersion":"0.3.0",
   "name":"azure",
   "plugins":[
      {
         "type":"azure-vnet",
         "mode":"transparent",
         "executionMode":"v4swift",
         "ipsToRouteViaHost":["169.254.20.10"],
         "ipam":{
            "type":"azure-cns",
            "mode":"v4overlay"
         }
      },
      {
         "type":"portmap",
         "capabilities":{
            "portMappings":true
         },
         "snat":true
      }
   ]
}
```

### After Upgrade to Cilium Enterprise Edition (CEE)

```json
{
  "cniVersion": "0.3.1",
  "name": "cilium",
  "type": "cilium-cni",
  "enable-debug": false,
  "log-file": "/var/run/cilium/cilium-cni.log"
}
```

---

## 3. Azure CNI with Dynamic IP Allocation

Dynamic IP allocation enables efficient IP address management without pre-reserving IPs per node.

### Default Configuration

```json
{
   "cniVersion":"0.3.0",
   "name":"azure",
   "plugins":[
      {
         "type":"azure-vnet",
         "mode":"transparent",
         "executionMode":"v4swift",
         "ipsToRouteViaHost":["169.254.20.10"],
         "ipam":{
            "type":"azure-cns"
         }
      },
      {
         "type":"portmap",
         "capabilities":{
            "portMappings":true
         },
         "snat":true
      }
   ]
}
```

### After Upgrade to Cilium Enterprise Edition (CEE)

```json
{
  "cniVersion": "0.3.1",
  "name": "cilium",
  "type": "cilium-cni",
  "enable-debug": false,
  "log-file": "/var/run/cilium/cilium-cni.log"
}
```

---

## 4. Bring Your Own CNI (BYOCNI)

When using BYOCNI, AKS does not provide a default CNI. Once Cilium is installed, the configuration becomes:

### Default (No CNI Provided by AKS)

No default CNI must be installed separately.configuration

### After Cilium Installation

```json
{
  "cniVersion": "0.3.1",
  "name": "cilium",
  "type": "cilium-cni",
  "enable-debug": false,
  "log-file": "/var/run/cilium/cilium-cni.log"
}
```

---

## 5. Azure CNI Powered by Cilium

This mode uses Cilium as the CNI with Azure IPAM integration.

### Default Configuration

```json
{
    "cniVersion": "0.3.1",
    "name": "cilium",
    "plugins": [
        {
            "type": "cilium-cni",
            "ipam": {
                "type": "azure-ipam"
            },
            "enable-debug": true,
            "log-file": "/var/log/cilium-cni.log"
        }
    ]
}
```

---

## 6. Kubenet

Traditional Kubernetes networking using bridge and host-local IPAM.

### Default Configuration

```json
{
    "cniVersion": "0.3.1",
    "name": "kubenet",
    "plugins": [
        {
            "type": "bridge",
            "bridge": "cbr0",
            "mtu": 1500,
            "addIf": "eth0",
            "isGateway": true,
            "ipMasq": false,
            "promiscMode": true,
            "hairpinMode": false,
            "ipam": {
                "type": "host-local",
                "ranges": [[{"subnet": "10.10.1.0/24"}]],
                "routes": [{"dst": "0.0.0.0/0"}]
            }
        },
        {
            "type": "portmap",
            "capabilities": {"portMappings": true},
            "externalSetMarkChain": "KUBE-MARK-MASQ"
        }
    ]
}
```

---

## 7. Isovalent Enterprise for Cilium (Azure Marketplace)

This is Cilium running as a delegated plugin with Azure IPAM integration.

### Default Configuration

```json
{
    "cniVersion": "0.3.1",
    "name": "cilium",
    "plugins": [
        {
            "type": "cilium-cni",
            "ipam": {
                "type": "azure-ipam"
            },
            "enable-debug": true,
            "log-file": "/var/log/cilium-cni.log"
        }
    ]
}
```

---

## Configuration Comparison

| Mode | IPAM Type | Primary Plugin | Typical Use Case |
| --- | --- | --- | --- |
| **Azure CNI** | azure-vnet-ipam | azure-vnet | Legacy Azure networking |
| **Azure CNI Overlay** | azure-cns (v4overlay) | azure-vnet | Large-scale clusters, IP efficiency |
| **Azure CNI Dynamic IP** | azure-cns | azure-vnet | Flexible IP allocation |
| **BYOCNI** | Custom | User-provided | Custom CNI requirements |
| **Azure CNI + Cilium** | azure-ipam | cilium-cni | Advanced policy, observability |
| **Kubenet** | host-local | bridge | IP-constrained environments |
| **Cilium (Isovalent)** | azure-ipam | cilium-cni | Enterprise Cilium support |

---

## Key Terms

| Term | Definition |
| --- | --- |
| **CNI Version** | Container Network Interface specification version |
| **IPAM** | IP Address Management - handles pod IP allocation |
| **Portmap** | Plugin enabling port mapping for services |
| **SNAT** | Source Network Address Translation for outbound traffic |
| **Debug Mode** | Enables verbose logging for troubleshooting |
| **Execution Mode** | Defines how the CNI processes network requests |

---

## Notes

- When upgrading from traditional Azure CNI to Cilium, the configuration file is replaced entirely.
- CEE (Cilium Enterprise Edition) provides additional features like advanced security policies and eBPF-based observability.
- Always test CNI configuration changes in a non-production environment first.
- The DNS IP (`169.254.20.10`) is a link-local address reserved for NodeLocal DNSCache communication.
