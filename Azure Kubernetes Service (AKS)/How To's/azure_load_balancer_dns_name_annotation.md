# How to set DNS name for a k8s service?

- Key is to use a unique name for the k8s service.

```yaml
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: nginx
  annotations:
    service.beta.kubernetes.io/azure-dns-label-name: amitmavgupta-cilium-rocks
  name: nginx-ipv4
spec:
  externalTrafficPolicy: Cluster
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: nginx
  type: LoadBalancer
---
```