
1. Check service dhcpd
```
    sudo systemctl enable dhcpcd
```
2. Folder tree 
```
    root
    ├── etc
    │   └── dhcpcd.conf (static ip)
    └── network
        └── interfaces (interfaces file used by ifup and ifdown)
```
