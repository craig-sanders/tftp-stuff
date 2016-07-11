#!/bin/bash

# ip address
# use first arg or contents of file '/ftp/ip'
config_ip=$(awk -F'[[:space:]]*=[[:space:]]*' '$1 == "IP" {print $2}' ../config)
ip=${1:-$config_ip}

[ -z "$ip" ] && echo "ip address required!" && exit 1

dir=$(pwd)
sshpwd=$(cat ./protected/sshpwd)
usercrypted=''
if [ -n "$sshpwd" ] ; then
  sshencpwd=$(echo "$sshpwd" | mkpasswd -s)
  usercrypted="usercrypted=$sshencpwd"
fi


declare -a app_old app_new app_com
app_com=(
         ocs_live_batch=no
         ocs_prerun1="\"wget http://$ip/tftp/cz/extras/custom-ocs-2 -O /tmp/custom-ocs-2\""
         ocs_prerun2=sync
         ocs_live_run=\"bash /tmp/custom-ocs-2\"
         $usercrypted ocs_daemonon=ssh
         locales=en_AU.UTF-8 nolocales
         vga=ask
        )

app_old=(boot=live live-config noswap edd=on nomodeset
         ocs_live_keymap=NONE
         keyboard-layouts=NONE
        )

app_new=(boot=live live-config components union=overlay noswap edd=on nomodeset
         keyboard-layouts=NONE
        )

cat default.head

for i in $(/bin/ls -1rd [0-9]*/* 2>/dev/null | sort -V -r) ; do

  arch=${i/*\//}
  vers=${i/\/*/}

  # check if we are processing NEW version of clonezilla - compare versions using sort -V
  newversion=''
  compvers=$(printf "%s\n" "2.4.6-25" "$vers" | sort -V -r | head -n 1)
  test "$compvers" = "$i" && newversion="true"
  #declare -p v compvers newversion  | sed -e 's/declare -- //' | xargs

  if [ -d "$dir/$vers/$arch" ] ; then
    #echo -n " $arch" >&2

    czpath="http://$ip/tftp/cz/$vers/$arch"

    kernel="${czpath}/"$(basename $(ls -1td "${vers}/${arch}"/*linu*      | head -1))
    initrd="${czpath}/"$(basename $(ls -1td "${vers}/${arch}"/initrd*     | head -1))
    squash="${czpath}/"$(basename $(ls -1td "${vers}/${arch}"/*.squashfs* | head -1))

    if [ -z "$newversion" ] ; then
      # clonezilla version newer than 2.4.6-25
      cat <<__EOF__

LABEL cz-${i/\//-}
    MENU LABEL Clonezilla $vers ($arch)
    KERNEL $kernel
    APPEND initrd=$initrd ${app_old[@]} ${app_com[@]} fetch=$squash
__EOF__
    else
      # clonezilla version older than 2.4.6-25
      cat <<__EOF__

LABEL cz-${i/\//-}
    MENU LABEL Clonezilla $vers ($arch)
    KERNEL $kernel
    APPEND initrd=$initrd ${app_new[@]} ${app_com[@]} fetch=$squash
__EOF__
    fi
  fi

  echo
  #echo "MENU SEPARATOR"
done

cat default.tail ../return

exit 0
