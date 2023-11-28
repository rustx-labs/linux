#!/bin/bash

BUSYBOX=../busybox-1.36.1
INITRD=${PWD}/initramfs.cpio.gz
BUSYBOX_INSTALL_DIR=$BUSYBOX/_install
MODULE_DIR=/lib/modules

cat <<EOF > $BUSYBOX_INSTALL_DIR/init
#!/bin/busybox sh

/bin/busybox mkdir -p /proc && /bin/busybox mount -t proc none /proc

/bin/busybox echo -e "\033[33m[$(date)] Hello, Welcome to Rust for Linux! \033[0m"

/bin/busybox ls $MODULE_DIR
# /bin/busybox insmod $MODULE_DIR/e1000_for_linux.ko

/bin/busybox ip addr add 127.0.0.1/32 dev lo
/bin/busybox ip link set lo up

/bin/busybox ip addr add 192.168.100.223/24 dev eth0
/bin/busybox ip link set eth0 up

export 'PS1=(kernel) >'
/bin/busybox sh
EOF

# 参考这里: https://www.jianshu.com/p/9b68e9ea5849
# Set host-only network
if [ "$1" == "init-host-only" ]; then
  sudo ip link add br0 type bridge
  sudo ip addr add 192.168.100.50/24 brd 192.168.100.255 dev br0
  sudo ip tuntap add mode tap user $(whoami)
  ip tuntap show
  sudo ip link set tap0 master br0
  sudo ip link set dev br0 up
  sudo ip link set dev tap0 up
fi

chmod +x $BUSYBOX_INSTALL_DIR/init

mkdir -p $BUSYBOX_INSTALL_DIR/$MODULE_DIR/

cp ../virtio-drivers/src/virtio_for_linux.ko $BUSYBOX_INSTALL_DIR/$MODULE_DIR/

cd $BUSYBOX_INSTALL_DIR && find . -print0 | cpio --null -ov --format=newc | gzip -9 > ${INITRD} && cd -

qemu-system-aarch64 \
  -kernel ./build/arch/arm64/boot/Image.gz \
  -initrd ${INITRD} \
  -M virt \
  -cpu cortex-a72 \
  -smp 2 \
  -m 128M \
  -nographic \
  -append 'init=/init console=ttyAMA0'
  # -netdev tap,ifname=tap0,id=tap0,script=no,downscript=no -device e1000,netdev=tap0 \
  # -append 'init=/init console=ttyAMA0'
