#! /bin/bash

# update-kernel.sh
#
# Installs a different kernel, /lib/modules, and /lib/firmware
# into the dists linux and initrd.gz
# 
# defaults to using the latest installed kernel 
#
# Craig Sanders <cas@taz.net.au>

usage() {
  [ -n "$*" ] && printf "%s\n\n" "$*" && exit 1
  
  cat >&2 <<__EOF__
$0 [options]

Options:
    -k  kernel to install            (default: latest)
    -c  install currently-running kernel

    -d  distro to modify             (default: latest)

    -h  This help message.
__EOF__
  exit 1
}

dist=$( /bin/ls -1rd [0-9]* | sort -V -r | head -n 1 )
kern=$( ( uname -r ; /bin/ls -1 /var/lib/initramfs-tools) || sort -V -r | head -n 1 )

while getopts ':hclk:d:' opt ; do
  case "$opt" in
     c) kern="$(uname -r)" ;;
     l) dist="" ; kern="" ;;
     k) kern="$OPTARG" ;;
     d) dist="$OPTARG" ;;
     h) usage ;;
    \?) usage "ERROR: Unknown option -$OPTARG" ;;
     :) usage "ERROR: -$OPTARG requires an argument" ;;
  esac
done
shift $((OPTIND-1))

#echo kern=$kern
#echo dist=$dist

if [ -z "$dist" ] && [ -z "$kern" ] ; then
   echo "Distributions:"
   /bin/ls -1rd [0-9]* | sort -V -r
   echo
   echo "Kernels:"
   ( uname -r ; /bin/ls -1 /var/lib/initramfs-tools) | sort -V -r -u
   echo
  exit 1
fi

[ ! -d "$dist" ] && usage "$(pwd)/$dist does not exist"
[ ! -d "/lib/modules/$kern"  ] && usage "kernel modules directory /lib/modules/$kern does not exist"
[ ! -f "/boot/vmlinuz-$kern" ] && usage "kernel /boot/vmlinuz-$kern does not exist"

set -x

cd "$dist/amd64"

kfile='linux'
[ -e "$kfile" ] || kfile='vmlinuz'
[ -e "$kfile" ] || usage "ERROR: Unknown kernel file in $(pwd)"

# find the initrd file.  may be initrd.gz, initrd.img. etc.
initrd=$(find . -maxdepth 1 -iname '*initrd*' -printf "%P\n" | head -n 1)

# now find the initrd's compression type
ftype=$(file --mime-encoding "$initrd")
compress=''
case "$ftype" in
  *x-xz*) compress='xz' ;;
  *gzip*) compress='gzip' ;;
  *bzip*) compress='bzip2' ;;
esac

[ -n "$compress" ] || usage "ERROR: unknown compression format for initrd in $(pwd)"

mkdir orig
mv "$kfile" "$initrd" orig

cp -af "/boot/vmlinuz-$kern" ./linux

mkdir initrd
cd initrd
$compress -d "../orig/$initrd" | cpio -i --no-absolute-filenames 

cp -af "/lib/modules/$kern/" lib/modules/
cp -af /lib/firmware/ lib/

find . | cpio -o -H newc | $compress -c > ../"$initrd"
cd ..
rm -rf ./initrd/

