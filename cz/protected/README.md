This directory contains files that **MUST** not be available to either
the tftpd or the httpd.

They are intended for use by the scripts run on the tftp server
only.

Directory should be 0700 and all files in it should be 0600.

# sshpwd 

This file contains an unencrypted password while will be encrypted and
added to the APPEND lines for cz MENU items, making it easy to ssh into
a machine running a netbooted clonezilla.

