# Google Cloud Shell Commands

## Connect to Cloud Shell via SSH

```bash
gcloud cloud-shell ssh --command=ls
```

Output:
```
Automatic authentication with GCP CLI tools in Cloud Shell is disabled. To enable, please rerun command with `--authorize-session` flag.
README-cloudshell.txt
```

## Open Cloud Shell

```bash
gcloud cloud-shell ssh
```

Output:
```
Automatic authentication with GCP CLI tools in Cloud Shell is disabled. To enable, please rerun command with `--authorize-session` flag.
Welcome to Cloud Shell! Type "help" to get started.
Your Cloud Platform project in this session is set to cilium-dev.
Use "gcloud config set project [PROJECT_ID]" to change to a different project.
```

## Exit Cloud Shell

```bash
exit
```

## Set GCP Project

```bash
gcloud config set project cilium-demo
```

Output:
```
Updated property [core/project].
```

## Copy Files from Compute Instance

```bash
gcloud compute scp amit-iso-ent://home/amit/export.log /Users/amit/Downloads/
```

## List Compute Instances

```bash
gcloud compute instances list
```

## Update gcloud Components

To revert to a previously installed version:
```bash
gcloud components update --version 413.0.0
```
