# How to remove ancient DNF repos?

- How to remove ancient DNF repos
```
dnf repolist
dnf repository-packages ancient-repo remove
rm /etc/yum.repos.d/ancient-repo.repo
```