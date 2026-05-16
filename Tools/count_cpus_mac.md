# Count Number of CPUs on Mac

To check the number of CPU cores on your Mac, use:

```bash
sysctl -n hw.ncpu
```

### Example Output

```
10
```

### Alternative Commands

- Get detailed CPU information:
```bash
sysctl hw.physicalcpu
sysctl hw.logicalcpu
```

- Using system_profiler:
```bash
system_profiler SPHardwareDataType | grep "Cores:"
```

This command will return the total number of CPU cores available on your Mac.
