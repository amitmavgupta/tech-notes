# How to fix the issue when the bootstrap or EKS Anywhere Docker cluster pods show error: too many open files?

- Change the existing values of default <[inotify](https://linux.die.net/man/7/inotify)> resources to take effect on runtime

**From**

```
#sysctl fs.inotify.max_user_watches
#fs.inotify.max_user_watches = 148727

#sysctl fs.inotify.max_user_instances
#fs.inotify.max_user_instances = 128
```
**To**
```
#sudo sysctl fs.inotify.max_user_instances=512
#sudo sysctl fs.inotify.max_user_watches=524288
```
- To make the changes persistent, edit the file /etc/sysctl.conf and add these lines:
```
fs.inotify.max_user_watches = 524288
fs.inotify.max_user_instances = 512
```
