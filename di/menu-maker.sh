#!/bin/bash

# ip address: use first arg or read from ../config
config_ip=$(awk -F'[[:space:]]*=[[:space:]]*' '$1 == "IP" {print $2}' ../config)
ip=${1:-$config_ip}

[ -z "$ip" ] && echo "ip address required!" && exit 1

cat default.head
# descending sort dists, ascending sort arches.  amd64 before i386, unstable and testing before stable.
dists=( $(find .  -mindepth 2 -maxdepth 2 -type d -name '[a-z]*' | sed -e 's:^./::' |  sort -t/ -k2,2 -k1,1r) )

[ -e 'preseed.cfg' ] && preseed="preseed/url=http://$IP/tftp/di/preseed.cfg"

for i in "${dists[@]}" ; do

  arch=${i/*\//}
  dist=${i/\/*/}

  cat <<__EOF__ 

LABEL $dist-$arch
    MENU LABEL $dist Debian Installer $arch
    kernel http://$IP/tftp/di/$dist/$arch/linux
    append initrd=http://$IP/tftp/di/$dist/$arch/initrd.gz vga=normal priority=low $preseed --

__EOF__

done

cat ../return default.tail 

exit 0
