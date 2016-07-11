#! /bin/bash

#baseurl='http://ftp.debian.org/debian/'
config_di=$(awk -F'[[:space:]]*=[[:space:]]*' '$1 == "DEBIAN" {print $2}' ../config | tail -n 1)
base_url="$config_di"

[ -z "$base_url" ] && echo "debian mirror site required!" && exit 1
# default to fetching stable amd64 installer
dist=${1:-stable}
arch=${2:-amd64}

echo wget -q --show-progress -O "netboot-$dist-$arch.tar.gz" "$base_url/dists/$dist/main/installer-$arch/current/images/netboot/netboot.tar.gz"
#wget -q --show-progress -O "netboot-$dist-$arch.tar.gz" "$base_url/dists/$dist/main/installer-$arch/current/images/netboot/netboot.tar.gz"
wget  -O "netboot-$dist-$arch.tar.gz" "$base_url/dists/$dist/main/installer-$arch/current/images/netboot/netboot.tar.gz"

