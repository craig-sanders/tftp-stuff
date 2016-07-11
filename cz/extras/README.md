# extras/

This directory contains files that **MUST** be available to both the
tftpd and the httpd.

They are downloaded to the running netbooted clonezilla instance.

They should **NOT** contain any sensitive information like passwords
or private keys because they will be accessible by any machine on the
network that has access to the tftp server or the /tftp/ directory in
the httpd config.

---

 - `custom-ocs-2`

 custom setup for clonezilla. also downloads and makes use of the following files:

 - `bash.aliases`

 useful aliases added to the shell

 - `cz.profile.add`

 added to the shell's various profile files

 - `cz.ssh.keys`

 ssh keys that are automatically added to user's and root's
`~/.ssh/authorized_keys` file.

