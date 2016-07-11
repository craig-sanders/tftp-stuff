
DEFAULT http://__IP__/tftp/menu.c32

PROMPT 0
TIMEOUT 120
MENU ROWS 14

LABEL local
    MENU DEFAULT
    MENU LABEL Boot from Local Hard Disk
    KERNEL http://__IP__/tftp/chain.c32
    APPEND hd0 0

MENU SEPARATOR

LABEL dimenu
	MENU LABEL Debian ^Installer Menu
	KERNEL http://__IP__/tftp/menu.c32
	APPEND http://__IP__/tftp/di/default

LABEL dlmenu
	MENU LABEL ^Debian Live Menu
	KERNEL http://__IP__/tftp/menu.c32
	APPEND http://__IP__/tftp/dl/default

MENU SEPARATOR

LABEL ^czmenu
	MENU LABEL Clonezilla Menu
	KERNEL http://__IP__/tftp/menu.c32
	APPEND http://__IP__/tftp/cz/default

MENU SEPARATOR

LABEL gpmenu
	MENU LABEL ^GParted Menu
	KERNEL http://__IP__/tftp/menu.c32
	APPEND http://__IP__/tftp/gp/default

MENU SEPARATOR

LABEL fdmenu
	MENU LABEL ^Freedos images Menu
	KERNEL http://__IP__/tftp/menu.c32
	APPEND http://__IP__/tftp/freedos/default

