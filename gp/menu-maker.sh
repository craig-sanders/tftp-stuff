#!/bin/bash

# ip address
# use first arg or contents of file '/ftp/ip'
config_ip=$(awk -F'[[:space:]]*=[[:space:]]*' '$1 == "IP" {print $2}' ../config)
ip=${1:-$config_ip}

[ -z "$ip" ] && echo "ip address required!" && exit 1

# for info on the usercrypted passwd see http://clonezilla.org/clonezilla-live/doc/showcontent.php?topic=05_Started_with_sshd_on_and_passwd_assigned

vga='ask'
#vga='normal'

declare -a app_com app_old app_new
app_old=( 
         boot=live
         config
         union=aufs
        )

app_new=(
         boot=live
         config
         components
         union=overlay
        )

app_com=(
         "live-config.locales=en_AU.UTF-8"
         "live-config.timezone=Australia/Melbourne"
         "keyboard-layouts=NONE"
         "live-config.username=user"
         noswap
         noprompt
         noeject
         "vga=$vga"
        )

for i in $(/bin/ls -1rd [0-9]*/* 2>/dev/null | sort -V -r) ; do

  vmlinuz="tftp/gp/$(ls -1 $i/vmlinuz* | head -1)"
  initrd="tftp/gp/$(ls -1 $i/initrd* | head -1)"
  squash="tftp/gp/$(ls -1 $i/*.squashfs* | head -1)"

  arch=${i/*\//}
  vers=${i/\/*/}

  # check if we are processing NEW version of gparted - compare versions using sort -V
  NEWVERSION=''
  compvers=$(printf "%s\n" "0.22.0-1" "$i" | sort -V -r | head -n 1)
  test "$compvers" = "$i" && NEWVERSION="true"
  #declare -p i compvers NEWVERSION  | sed -e 's/declare -- //' | xargs

  if [ -z "$NEWVERSION"  ] ; then
    # for gparted versions older than 0.22.0-1
    #  APPEND initrd=http://$ip/$initrd boot=live config union=aufs radeon.modeset=0 noswap noprompt vga=ask fetch=http://$ip/$squash
    cat <<__EOF__

LABEL gp$vers-$arch
    MENU LABEL GParted Live $vers $arch
    KERNEL http://$ip/$vmlinuz
    APPEND initrd=http://$ip/$initrd ${app_old[@]} ${app_com[@]} radeon.modeset=0 fetch=http://$ip/$squash

__EOF__

    else
  # for gparted versions newer than 0.22.0-1
    cat <<__EOF__

LABEL gp$vers-$arch
    MENU LABEL GParted Live $vers $arch
    KERNEL http://$ip/$vmlinuz
    APPEND initrd=http://$ip/$initrd ${app_new[@]} ${app_com[@]} fetch=http://$ip/$squash

__EOF__
  fi

done
