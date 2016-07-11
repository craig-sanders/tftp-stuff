# tftp-stuff

## Scripts to maintain menus for netbootable:

 - Clonezilla (cz/)
 - GParted (gp/)
 - Debian Installer (di/)

 - auto-download and unpack images for all of the above.

 - Makefile used as sysadmin tool to automate common tasks

## still to come...

I need to clean up and generalise my tftp scripts for:

 - memdisk floppy and ISO images
 - freedos images (useful for, e.g., BIOS updates)

## Requirements:

 - a tftp server serving from e.g. /src/tftp/
   - I use tftpd-hpa

 - a web server:
   - need to manually create apache/nginx/etc aliases for /tftp to point to /srv/tftp/

Convenience tip: make the same absolute path work in bash too:

    ln -s /srv/tftp/ /

 - syslinux 
   - install syslinux package(s)
   - copy chain.c32 menu.c32 memdisk (or `*.c32`) to /tftp/

## TODO: needs better readme (and wiki other docs)
