#!/bin/bash

sudo rm -rf ./_install ./rootfs.cpio.gz;
make defconfig;
sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config;
export CROSS_COMPILE=/media/shc/0EDEBC4906059163/tools/riscv-toolchain-linux/_install/bin/riscv32-unknown-linux-gnu-;
make -j14;
make install;
cd _install;
mkdir -p dev proc sys etc/init.d;
#sudo rm -rf dev/console dev/null;
sudo mknod dev/console c 5 1;
sudo mknod dev/null c 1 3;

echo '#!/bin/sh' > ./etc/init.d/rcS
echo 'mount -t proc none /proc' >> ./etc/init.d/rcS
echo 'mount -t sysfs none /sys' >> ./etc/init.d/rcS
echo 'echo " "' >> ./etc/init.d/rcS
echo 'echo "##################################"' >> ./etc/init.d/rcS
echo 'echo "#   CustomSoC Linux Booted!      #"' >> ./etc/init.d/rcS
echo 'echo "##################################"' >> ./etc/init.d/rcS
echo 'echo " "' >> ./etc/init.d/rcS
echo 'echo "Starting shell..."' >> ./etc/init.d/rcS
#echo 'ls -al' >> ./etc/init.d/rcS
echo 'exec /bin/sh' >> ./etc/init.d/rcS

chmod +x ./etc/init.d/rcS;
ln -s ./etc/init.d/rcS ./init;
find . | cpio -H newc -o --owner root:root | gzip > ../rootfs.cpio.gz;
