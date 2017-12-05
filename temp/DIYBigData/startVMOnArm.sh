#!/bin/bash
set +x

kernel=zImage
dtb=rtsm_ve-cortex_a15x1.dtb

qemu-system-arm \
-enable-kvm -serial stdio -kernel $kernel -dtb $dtb \
-m 512 -M vexpress-a15 -cpu cortex-a15 \
-drive file=android.jb.img,id=virtio-blk,if=none \
-device virtio-blk-device,drive=virtio-blk \
-netdev type=tap,id=net1,script=no,downscript=no,ifname="tap0" \
-device virtio-net-device,netdev=net1,mac="52:54:00:12:34:56" \
-append "earlyprintk=ttyAMA0 console=ttyAMA0 root=/dev/vda rw ip=dhcp init=/init"
