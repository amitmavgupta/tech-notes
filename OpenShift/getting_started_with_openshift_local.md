# OpenShift Local Setup

This guide covers installing [OpenShift Local] (https://openshift.guide/getting-started/openshift-local.html) (formerly CodeReady Containers).

---

## Part 1: Install OpenShift Local (CRC)

### Prerequisites

- macOS 13.x or later
- 4 vCPU's and 16GB or RAM (32GB is recommended)
- Sufficient disk space (at least 31 GiB)
- Download the CRC macOS installer from Red Hat
- Obtain a pull secret from https://console.redhat.com/openshift/create/local

### Step 1: Extract and Install CRC

```bash
cd ~/Downloads
tar xvf crc-macos-installer.pkg
mkdir -p ~/bin
cp ~/Downloads/crc-macos-installer.pkg ~/bin
```

### Step 2: Run CRC Setup

```bash
crc setup
```

When prompted about telemetry:
```
Would you like to contribute anonymous usage statistics? [y/N]: y
```

**Expected Output:**
```
INFO Creating symlink for crc executable
INFO Checking minimum RAM requirements
INFO Checking if vfkit is installed
...
Your system is correctly setup for using CRC. Use 'crc start' to start the instance
```

### Step 3: Configure Resources

Check available configuration options:

```bash
crc config --help
```

Set CPU and memory allocations (adjust based on your system):

```bash
crc config set cpus 4
crc config set memory 16384
```

**Note:** These changes only take effect when starting or restarting the CRC instance.

### Step 4: Check CRC Version

```bash
crc version
```

**Expected Output:**
```
CRC version: 2.52.0+47be8d
OpenShift version: 4.19.0
MicroShift version: 4.19.0
```

### Step 5: View Current Configuration

```bash
crc config view
```

### Step 6: Start CRC Instance

```bash
crc start -p ~/Downloads/pull-secret.txt
```

**Expected Output:**
```
INFO Loading bundle: crc_vfkit_4.19.0_arm64...
INFO Creating CRC VM for OpenShift 4.19.0...
INFO Generating new SSH key pair...
INFO Starting CRC VM for openshift 4.19.0...
...
Started the OpenShift cluster.

The server is accessible via web console at:
  https://console-openshift-console.apps-crc.testing

Log in as administrator:
  Username: kubeadmin
  Password: [GENERATED_PASSWORD]

Log in as user:
  Username: developer
  Password: developer
```

### Step 7: Configure CLI Environment

```bash
eval $(crc oc-env)
oc login -u developer https://api.crc.testing:6443
```

### Step 8: Create a Project

```bash
oc new-project default
```

Or create a custom project:

```bash
oc new-project <project-name>
```

### Step 9: Verify Cluster Health

Check if you have cluster admin access:

```bash
oc login -u kubeadmin https://api.crc.testing:6443
```

View all running pods across the cluster:

```bash
oc get pods -A -o wide
```

Get cluster nodes:

```bash
oc get nodes -o wide
```

## Stopping the OpenShift Local Instance

When you're done working with your local OpenShift cluster:

```bash
crc stop
```

**Expected Output:**
```
INFO Stopping kubelet and all containers...
INFO Stopping the instance, this may take a few minutes...
Stopped the instance
```

---

## Useful Commands Reference

| Command | Purpose |
| --- | --- |
| `crc setup` | Initialize CRC with system prerequisites |
| `crc start` | Start the OpenShift Local instance |
| `crc stop` | Stop the running instance |
| `crc config set <property> <value>` | Configure CRC settings |
| `crc config view` | View current CRC configuration |
| `crc version` | Display CRC and OpenShift versions |
| `oc login -u <user> <api-url>` | Authenticate to OpenShift cluster |
| `oc new-project <name>` | Create a new project/namespace |
| `oc get pods -A` | List all pods across all namespaces |
| `kubectl apply -f <url>` | Apply Kubernetes resources |
| `helm install <release> <chart>` | Install Helm chart |
| `helm repo add <name> <url>` | Add Helm repository |

---

## Troubleshooting

### Pod Status Shows ImagePullBackOff

- This is common in isolated environments without internet access to registries
- The core functionality still works despite marketplace operator failures

### Check if the ingress route is configured:

```bash
kubectl get ingress
kubectl get routes
```

---

## Security Considerations

- **Development Only**: This setup is for development and testing purposes
- **Pull Secrets**: The pull secret is required for accessing Red Hat container registries
- **Network Access**: By default, CRC is accessible only from the local machine

For production deployments, refer to:
- [Red Hat OpenShift Documentation](https://docs.openshift.com/)
