# ROSA CLI Upgrade Guide

How to upgrade the ROSA CLI (Red Hat OpenShift Service on AWS Command Line Interface) on your workstation.

This guide assumes that [ROSA CLI](https://docs.redhat.com/en/documentation/red_hat_openshift_service_on_aws/4/html/rosa_cli/rosa-get-started-cli#rosa-setting-up-cli_rosa-getting-started-cli) has been previously configured on your workstation.

---

## Overview

The ROSA CLI is the primary tool for managing Red Hat OpenShift Service on AWS (ROSA) clusters. Regular updates ensure access to new features, bug fixes, and security patches.

### Why Upgrade?
- **New features**: Latest cluster capabilities and configuration options
- **Security patches**: Address vulnerabilities in CLI and dependencies
- **Bug fixes**: Resolve known issues with cluster operations
- **Compatibility**: Ensure compatibility with latest ROSA API versions

---

## Prerequisites

- ROSA CLI already installed on your workstation
- macOS, Linux, or WSL2 development environment
- Internet connectivity to download the ROSA client
- `sudo` access to update system binaries (for `/usr/local/bin/` installation)

---

## Upgrade Steps

### 1. Download the Latest ROSA Client

List available versions and download the latest release:

```bash
rosa download rosa-client
```

Expected output:
```
I: Downloading https://mirror.openshift.com/pub/openshift-v4/clients/rosa/latest/rosa-linux.tar.gz to your current directory
Downloading... 36 MB complete
I: Successfully downloaded rosa-linux.tar.gz
```

### 2. Extract the Archive

```bash
tar xvf rosa-linux.tar.gz
```

This extracts the `rosa` binary to your current directory.

### 3. Verify the Downloaded Binary

```bash
./rosa version
```

Expected output (varies by version):
```
I: ROSA CLI is v1.2.50
I: Your ROSA CLI version is newer than the remote version.
```

### 4. Install to System Path

Move the binary to a location in your system PATH for easy access:

```bash
sudo mv rosa /usr/local/bin/rosa
```

### 5. Verify the Installation

Confirm the new version is now active:

```bash
rosa version
```

Expected output:
```
I: 1.2.50
I: Your ROSA CLI is up to date.
```

---

## Common Upgrade Scenarios

### Scenario 1: Standard Workstation Upgrade

1. Download latest ROSA client
2. Extract to temporary directory
3. Move binary to `/usr/local/bin/`
4. Verify version

### Scenario 2: Multiple Workstations

For teams managing multiple development machines:

```bash
# Create a shared installation directory
mkdir -p ~/rosa-clients/v1.2.50
cd ~/rosa-clients/v1.2.50
rosa download rosa-client
tar xvf rosa-linux.tar.gz
sudo cp rosa /usr/local/bin/rosa
```

### Scenario 3: Keeping Multiple Versions

If you need to maintain multiple ROSA CLI versions:

```bash
# Install versioned binaries
sudo mv rosa /usr/local/bin/rosa-1.2.50
sudo ln -s /usr/local/bin/rosa-1.2.50 /usr/local/bin/rosa
# Use alternate version when needed
/usr/local/bin/rosa-1.2.49 version
```

---

## Troubleshooting

### Issue: Permission Denied When Moving Binary

**Problem**: Cannot move binary to `/usr/local/bin/`

**Solution**: Use `sudo` with appropriate permissions:
```bash
sudo mv rosa /usr/local/bin/rosa
sudo chmod +x /usr/local/bin/rosa
```

### Issue: Command Not Found After Installation

**Problem**: `rosa` command not found in PATH

**Solution**: Verify installation and PATH:
```bash
which rosa
# If not found, check /usr/local/bin/
ls -la /usr/local/bin/rosa
# Verify PATH includes /usr/local/bin
echo $PATH
```

### Issue: Version Mismatch or Unexpected Behavior

**Problem**: Installed version differs from expected

**Solution**: Verify and reinstall:
```bash
rosa version
rm /usr/local/bin/rosa
rosa download rosa-client
tar xvf rosa-linux.tar.gz
sudo mv rosa /usr/local/bin/rosa
rosa version
```

---

## Verification Checklist

After upgrading ROSA CLI:

- [ ] Binary is executable: `ls -la /usr/local/bin/rosa`
- [ ] Version is updated: `rosa version`
- [ ] CLI responds to commands: `rosa whoami`
- [ ] Can authenticate: `rosa login`
- [ ] Can list clusters: `rosa list clusters`

---

## Best Practices

1. **Regular Updates**: Check for ROSA CLI updates monthly or when releasing new ROSA versions
2. **Backup Previous Version**: Keep backups of previous versions during upgrades
3. **Test First**: Verify CLI works in non-production environment after upgrade
4. **Team Coordination**: Notify team members about CLI upgrades to maintain consistency
5. **Document Version**: Track which CLI version your team is using
6. **Automate**: Use configuration management (Ansible, Chef) to automate CLI updates across teams

---

## Related Documentation

- **ROSA Service**: https://docs.redhat.com/en/documentation/red_hat_openshift_service_on_aws/
- **ROSA CLI Commands**: Run `rosa --help` for full command reference
- **OpenShift Documentation**: https://docs.openshift.com/
- **AWS Integration**: https://docs.aws.amazon.com/rosa/