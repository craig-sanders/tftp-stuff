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
# $2 = ip address.  if NUL, use contents of file 'ip' in current dir.
ip=${2:-$(cat ip)}

[ -z "$ip" ] && echo "IP address required!" && exit 1

for f in "${files[@]}" ; do 
  echo "creating: $f"
  sed -e "s/__IP__/$ip/g" "$f.tpl" > "$f"
done
