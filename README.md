# alpine-qinglong

- ## pve-backup
    链接：https://cowtransfer.com/s/93bf24227f8e42
    
    口令：1w0r0b
    
    user：root
    
    No password
    
- ## virt-install(pve or esxi)
```sh
ash -c "$(wget https://raw.githubusercontent.com/sundaqiang/alpine-qinglong/main/virt-install.sh -q -O -)"
```

- ## rootfs-install
```sh
chroot /opt/alpine /bin/ash -c "$(wget https://raw.githubusercontent.com/sundaqiang/alpine-qinglong/main/rootfs-install.sh -q -O -)"
```

- ## rootfs-start
```sh
chroot /opt/alpine /start.sh
```
