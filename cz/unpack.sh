#! /bin/sh

dir=$(pwd)

case "$dir" in 
  *cz*) project='clonezilla' ;;
  *gp*) project='gparted'    ;;
esac

# e.g. clonezilla-live-2.1.0-2-amd64.zip
#  or  gparted-live-0.26.0-2-amd64.zip
latest=$(/bin/ls -1t $project-live-* | head -n 1)
filename="${1:-$latest}"

if [ -z "$filename" ] || [ ! -e "$filename" ] ; then
  echo "An existing '$project--live*.zip' filename is required."
  echo
  echo "List of $project-live .zip files in the current dir ($dir):"
  ls $project--live* 2>/dev/null || printf "\n  %s\n" "   ** None. **" "Use 'fetch-update.sh --latest' to download the latest"
  exit 1
fi

vers=$(echo "$filename" | awk -F"-" -vOFS=- '{print $3,$4}')
arch=$(echo "$filename" | awk -F"[-.]" '{print $(NF-1)}')
declare -p filename vers arch

mkdir -p "$vers/$arch"
pushd "$vers/$arch"
unzip -j "$dir/$filename" live/*
popd
