#! /bin/bash

# e.g. netboot-stable-amd64.tar.gz
#filename="$1"
latest=$(ls -1t netboot-*.tar.gz | head -n 1)
filename="${1:-$latest}"

dir=$(pwd)

if [ -z "$filename" ] || [ ! -e "$filename" ] ; then
  echo "An existing 'netboot-*.tar.gz' filename is required."
  echo
  echo "List of $netboot-* tar.gz files in the current dir ($dir):"
  ls netboot-* 2>/dev/null || printf "\n  %s\n" "** None **" "Use './fetch-installer' to download the latest stable amd64 installer"
  exit 1
fi

[ -d "$dist" ] && mv "$dist" "$dist."$(date +%Y%m%d -d @$(stat -c %Y "$dist"))

set -x
dist=$(echo "$filename" | awk -F'[-.]' '{print $2}')
arch=$(echo "$filename" | awk -F'[-.]' '{print $3}')

mkdir -p ./tmp/
tar xfz "netboot-${dist}-${arch}.tar.gz" -C ./tmp/
rm -rf "${dist}/${arch}"
mkdir -p "${dist}/"
mv "./tmp/debian-installer/${arch}" "${dist}/"
rm -rf ./tmp/
