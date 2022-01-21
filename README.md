# alpine-qinglong

链接：https://cowtransfer.com/s/1f771efeb3b748

口令：doz3gh

user：root

No password


virt-install
```sh
ash -c "$(wget https://raw.githubusercontent.com/sundaqiang/alpine-qinglong/main/virt-install.sh -q -O -)"
```

rootfs-install
```sh
chroot /opt/alpine /bin/ash -c "$(wget https://raw.githubusercontent.com/sundaqiang/alpine-qinglong/main/rootfs-install.sh -q -O -)"
```

rootfs-start
```sh
chroot /opt/alpine /start.sh
```
