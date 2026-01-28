#!/bin/bash

sudo rm -rf ./_install ./rootfs.cpio.gz;
make defconfig;
sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config;
export CROSS_COMPILE=/media/shc/0EDEBC4906059163/tools/riscv-toolchain-linux/_install/bin/riscv32-unknown-linux-gnu-;
make -j14;
make install;

cp "/home/shc/projects/mibench/automotive/basicmath/basicmath_small" ./_install;
"${CROSS_COMPILE}strip" ./_install/basicmath_small;
cp "/home/shc/projects/mibench/automotive/basicmath/runme_small.sh" ./_install;

cp "/home/shc/projects/mibench/network/dijkstra/dijkstra_small" ./_install;
"${CROSS_COMPILE}strip" ./_install/dijkstra_small;
cp "/home/shc/projects/mibench/network/dijkstra/input.dat" ./_install;

cp "/home/shc/projects/mibench/office/stringsearch/search_small" ./_install;
"${CROSS_COMPILE}strip" ./_install/search_small;

cp "/home/shc/projects/mibench/security/rijndael/rijndael" ./_install;
"${CROSS_COMPILE}strip" ./_install/rijndael;
cp "/home/shc/projects/mibench/security/rijndael/input_small.asc" ./_install;

cp "/home/shc/projects/mibench/security/sha/sha" ./_install;
"${CROSS_COMPILE}strip" ./_install/sha;

cp "/home/shc/projects/mibench/telecomm/FFT/fft" ./_install;
"${CROSS_COMPILE}strip" ./_install/fft;

cp "/home/shc/projects/mibench/consumer/jpeg/jpeg-6a/cjpeg" ./_install;
cp "/home/shc/projects/mibench/consumer/jpeg/jpeg-6a/djpeg" ./_install;
"${CROSS_COMPILE}strip" ./_install/cjpeg;
"${CROSS_COMPILE}strip" ./_install/djpeg;
cp "/home/shc/projects/mibench/consumer/jpeg/input_small.ppm" ./_install;
cp "/home/shc/projects/mibench/consumer/jpeg/input_small.jpg" ./_install;

cp "./logo.txt" ./_install;

cd _install;
mkdir -p dev proc sys etc/init.d;
#sudo rm -rf dev/console dev/null;
sudo mknod dev/console c 5 1;
sudo mknod dev/null c 1 3;

echo '#!/bin/sh' > ./etc/init.d/rcS
echo 'mount -t proc none /proc' >> ./etc/init.d/rcS
echo 'mount -t sysfs none /sys' >> ./etc/init.d/rcS
#echo 'echo " "' >> ./etc/init.d/rcS
#echo 'echo "##################################"' >> ./etc/init.d/rcS
#echo 'echo "#   CustomSoC Linux Booted!      #"' >> ./etc/init.d/rcS
#echo 'echo "##################################"' >> ./etc/init.d/rcS
#echo 'echo " "' >> ./etc/init.d/rcS
echo 'cat logo.txt' >> ./etc/init.d/rcS
echo 'echo "Starting shell..."' >> ./etc/init.d/rcS
#echo 'ls -al' >> ./etc/init.d/rcS
#echo 'chmod +x ./basicmath_small' >> ./etc/init.d/rcS
#echo 'chmod +x ./runme_small.sh' >> ./etc/init.d/rcS
#echo 'time ./runme_small.sh' >> ./etc/init.d/rcS

echo './basicmath_small > output_small1.txt' >> ./etc/init.d/rcS
echo 'exec /bin/sh' >> ./etc/init.d/rcS

echo 'echo "Starting shell..."' >> ./etc/init.d/rcS
echo './dijkstra_small input.dat > output_small2.dat' >> ./etc/init.d/rcS
echo 'exec /bin/sh' >> ./etc/init.d/rcS

echo 'echo "Starting shell..."' >> ./etc/init.d/rcS
echo './search_small > output_small3.txt' >> ./etc/init.d/rcS
echo 'exec /bin/sh' >> ./etc/init.d/rcS

echo 'echo "Starting shell..."' >> ./etc/init.d/rcS
echo './rijndael input_small.asc output_small.enc e 1234567890abcdeffedcba09876543211234567890abcdeffedcba0987654321 && ./rijndael output_small.enc output_small.dec d 1234567890abcdeffedcba09876543211234567890abcdeffedcba0987654321' >> ./etc/init.d/rcS
echo 'exec /bin/sh' >> ./etc/init.d/rcS

echo 'echo "Starting shell..."' >> ./etc/init.d/rcS
echo './sha input_small.asc > output_small4.txt' >> ./etc/init.d/rcS
echo 'exec /bin/sh' >> ./etc/init.d/rcS

echo 'echo "Starting shell..."' >> ./etc/init.d/rcS
echo './fft 4 4096 > output_small.txt && ./fft 4 8192 -i > output_small.inv.txt' >> ./etc/init.d/rcS
echo 'exec /bin/sh' >> ./etc/init.d/rcS

echo 'echo "Starting shell..."' >> ./etc/init.d/rcS
echo './cjpeg -dct int -progressive -opt -outfile output_small_encode.jpeg input_small.ppm && ./djpeg -dct int -ppm -outfile output_small_decode.ppm input_small.jpg' >> ./etc/init.d/rcS

#echo 'tail -n 10 output_small.txt' >> ./etc/init.d/rcS
#echo 'cat output_small.txt' >> ./etc/init.d/rcS
echo 'exec /bin/sh' >> ./etc/init.d/rcS

chmod +x ./etc/init.d/rcS;
ln -s ./etc/init.d/rcS ./init;
#find . | cpio -H newc -o --owner root:root | gzip > ../rootfs.cpio.gz;
find . | cpio -H newc -o --owner root:root > ../rootfs.cpio;
