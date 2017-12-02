# KVM-tools
使用 KVM-tools 建立 ARMv7 環境的 ARM base single board virtualization 環境並可跨平台於
x86 base machine 使用。
# Root file system
Arm 平台使用 Odroid Xu4 作為單板機樣本擁有 8 核心 2 G 記憶體來使用。不使用 Armbian 與 arm-sdk 作為製作 Rootfs 方法。利用傳統 Debootstrap 製作
Rootfs 樣板並寫入至 Odroid Xu4 的 SD 卡與 EMMC 卡中。
