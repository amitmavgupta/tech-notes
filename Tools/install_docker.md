# Install Docker

## Ubuntu/Debian

- Run the following command to uninstall all conflicting packages:
```
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
```

- Add Docker's official GPG key:
```
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

- Add the repository to Apt sources:
```
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

- To install the latest version, run:
```
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

## CentOS

- Add Docker's official repository:
```
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager \
--add-repo=https://download.docker.com/linux/centos/docker-ce.repo
```

- Install Docker packages:
```
sudo dnf install -y docker-ce docker-ce-cli containerd.io
```

- Start and enable Docker:
```
sudo systemctl start docker
sudo systemctl enable docker
```

- Add your user to the docker group to run docker commands without sudo:
```
sudo usermod -aG docker $USER
newgrp docker
```

### Configure cgroupv2

- Check current cgroup version:
```
docker info | grep Cgroup
```

- Replace cgroupv1 with cgroupv2:
```
sudo grubby --update-kernel=/boot/vmlinuz-$(uname -r) --args="systemd.unified_cgroup_hierarchy=1"
sudo mount -t cgroup2 none /sys/fs/cgroup
```

- Verify cgroup2 is mounted:
```
mount | grep cgroup2
ls -lah /sys/fs/cgroup/
```