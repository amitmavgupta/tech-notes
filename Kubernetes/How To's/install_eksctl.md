# Install eksctl

```
curl "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" \
    --silent --location \
    | tar xz -C /tmp

sudo install -m 0755 /tmp/eksctl /usr/local/bin/eksctl
```