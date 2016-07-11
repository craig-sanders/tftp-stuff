#! /bin/sh

# $1 file to change: default, return, all
if [ "$1" == "all" ] ; then
  files=(default return)
else
  if [ -e "$1.tpl" ] ; then
    files=($1)
  else
    echo "$1.tpl does not exist".
    exit 1
  fi
fi

# IP address
# use second arg or read from ./config
config_ip=$(awk -F'[[:space:]]*=[[:space:]]*' '$1 == "IP" {print $2}' ../config)
ip=${2:-$config_ip}


[ -z "$ip" ] && echo "IP address required!" && exit 1

for f in "${files[@]}" ; do 
  echo "creating: $f"
  sed -e "s/__IP__/$ip/g" "$f.tpl" > "$f"
done
