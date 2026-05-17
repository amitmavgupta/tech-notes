# GKE Operations and Commands Guide

Essential gcloud CLI and kubectl commands for managing Google Kubernetes Engine (GKE) clusters and operations.

---

## gcloud Configuration and Project Management

### Set GCP Project

Set the default GCP project for all gcloud commands:

```bash
gcloud config set project <project-id>
```

**Output:**
```
Updated property [core/project].
```

### Verify Current Project

Check which project is currently configured:

```bash
gcloud config get-value project
```

### List Available Projects

View all projects accessible to your account:

```bash
gcloud projects list
```

---

## Google Cloud Shell

### Connect to Cloud Shell via SSH

Open Cloud Shell and execute commands remotely:

```bash
gcloud cloud-shell ssh --command=ls
```

**Output:**
```
Automatic authentication with GCP CLI tools in Cloud Shell is disabled. To enable, please rerun command with `--authorize-session` flag.
README-cloudshell.txt
```

### Open Interactive Cloud Shell

Start an interactive Cloud Shell session:

```bash
gcloud cloud-shell ssh
```

**Output:**
```
Automatic authentication with GCP CLI tools in Cloud Shell is disabled. To enable, please rerun command with `--authorize-session` flag.
Welcome to Cloud Shell! Type "help" to get started.
Your Cloud Platform project in this session is set to test.
Use "gcloud config set project [PROJECT_ID]" to change to a different project.
```

**Tip:** Add `--authorize-session` flag to enable automatic authentication with GCP CLI tools

### Exit Cloud Shell

Exit the interactive Cloud Shell session:

```bash
exit
```

---

## GKE Cluster Operations

### Get Cluster Credentials

Configure kubectl to access your GKE cluster:

```bash
gcloud container clusters get-credentials <cluster-name> \
    --region <region> \
    --project <project-id>
```

### List GKE Clusters

View all GKE clusters in your project:

```bash
gcloud container clusters list \
    --project <project-id>
```

### Describe Cluster Details

Get detailed information about a specific cluster:

```bash
gcloud container clusters describe <cluster-name> \
    --region <region> \
    --project <project-id>
```

### Delete GKE Cluster

Remove a GKE cluster permanently:

```bash
gcloud container clusters delete <cluster-name> \
    --region <region> \
    --project <project-id>
```

---

## Pod CIDR and Networking Queries

### Find Pod CIDR on GKE Cluster

Query the pod CIDR block allocated to your cluster:

```bash
gcloud container clusters describe amit-test-12345 \
    --zone=us-west2-a | grep -e podIpv4Cidr
```

**Output:**
```
podIpv4CidrBlock: 10.124.0.0/14
podIpv4CidrSize: 24
```

**Parameters:**
- `podIpv4CidrBlock`: Total pod CIDR block for the cluster
- `podIpv4CidrSize`: Pod CIDR block size per node (/24 = 256 addresses per node)

### Query Dual-Stack Pod CIDR

For dual-stack clusters, query both IPv4 and IPv6:

```bash
gcloud container clusters describe <cluster-name> \
    --region <region> | grep -E "podIpv4|podIpv6|serviceCidr"
```

### Get Service CIDR

Retrieve the service CIDR block:

```bash
gcloud container clusters describe <cluster-name> \
    --region <region> | grep serviceCidr
```

---

## Compute Instance Operations

### List Compute Instances

View all Compute Engine instances in your project:

```bash
gcloud compute instances list
```

### Copy Files from Compute Instance

Download files from a Compute Engine instance to your local machine:

```bash
gcloud compute scp <instance-name>://path/to/remote/file /local/path/
```

**Example:**
```bash
gcloud compute scp test://home/amit/export.log /Users/test/Downloads/
```

### Copy Files to Compute Instance

Upload files from local machine to a Compute Engine instance:

```bash
gcloud compute scp /local/path/file <instance-name>://path/to/remote/
```

### SSH to Compute Instance

Connect to a Compute Engine instance via SSH:

```bash
gcloud compute ssh <instance-name> --zone=<zone>
```

---

## kubectl Configuration in GKE

### Install gke-gcloud-auth-plugin

When using kubectl with GKE, install the authentication plugin:

```bash
apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
```

**On macOS (Homebrew):**
```bash
brew install google-cloud-sdk-gke-gcloud-auth-plugin
```

**Why needed:**
The `gke-gcloud-auth-plugin` implements the [Kubernetes Client-go Credential Plugin](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#client-go-credential-plugins) mechanism. This plugin extends kubectl's authentication to support GKE-specific authentication flows.

### Verify Plugin Installation

Check if the plugin is properly installed:

```bash
which gke-gcloud-auth-plugin
gke-gcloud-auth-plugin --version
```

### Configure kubectl Authentication

After installing the plugin, update your kubeconfig:

```bash
gcloud container clusters get-credentials <cluster-name> \
    --region <region> \
    --project <project-id>
```

This automatically configures kubectl to use the gke-gcloud-auth-plugin for authentication.

### Test kubectl Connectivity

Verify kubectl can communicate with your GKE cluster:

```bash
kubectl cluster-info
kubectl get nodes
kubectl get namespaces
```

---

## gcloud Components Management

### Update gcloud Components

Update all gcloud SDK components to the latest version:

```bash
gcloud components update
```

### Revert gcloud to Previous Version

Downgrade to a specific gcloud version:

```bash
gcloud components update --version <version-number>
```

**Example:**
```bash
gcloud components update --version 413.0.0
```

### List Installed Components

View all installed gcloud components:

```bash
gcloud components list
```

### Install Specific Component

Install individual gcloud components:

```bash
gcloud components install <component-name>
```

---

## Troubleshooting Common Issues

### Authentication Issues

If kubectl commands fail with authentication errors:

1. Verify gke-gcloud-auth-plugin is installed
2. Refresh cluster credentials:
   ```bash
   gcloud container clusters get-credentials <cluster-name> \
       --region <region> --project <project-id>
   ```
3. Check gcloud authentication:
   ```bash
   gcloud auth list
   gcloud auth login
   ```

### Cloud Shell SSH Issues

If Cloud Shell SSH fails:

1. Ensure you're authenticated: `gcloud auth login`
2. Try with authorization flag:
   ```bash
   gcloud cloud-shell ssh --authorize-session
   ```
3. Check if Cloud Shell is enabled in your project

### Pod CIDR Query Issues

If pod CIDR query returns no results:

1. Verify cluster is in running state
2. Use full region/zone specification
3. Ensure you have read permissions on the cluster

---

## Useful gcloud Aliases

Create shortcuts for frequently used commands:

```bash
# Set default region
gcloud config set compute/region us-central1

# Set default zone
gcloud config set compute/zone us-central1-a

# Create alias for cluster access
alias gke-prod='gcloud container clusters get-credentials prod-gke --region us-central1'
```

---

## Notes

- All commands use `gcloud` CLI (Google Cloud SDK v2.40+)
- `gke-gcloud-auth-plugin` is mandatory for recent GKE versions
- Pod CIDR and service CIDR are determined at cluster creation time
- Multi-cluster management requires updating kubeconfig or using context switching
- Cloud Shell provides ephemeral compute resources (temporary storage)
- File transfers via gcloud compute scp require SSH access permissions
- gcloud components auto-update can be disabled with: `gcloud config set component_manager/disable_update_check true`
