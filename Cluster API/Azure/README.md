# Cluster API Azure Assets

Helper files for Cluster API Provider Azure (CAPZ).

## Files
- `capi-aks.yaml`: Sample cluster manifest for Azure.
- `init.sh` and `create.sh`: bootstrap scripts for initializing CAPZ components and creating clusters.

Update the environment variables inside the scripts, run `init.sh` once per subscription, and execute `create.sh` when you need a new cluster.
