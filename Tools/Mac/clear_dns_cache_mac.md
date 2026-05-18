# How to clear DNS cache in Mac?

```
sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
```