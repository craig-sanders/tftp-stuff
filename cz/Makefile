#! /usr/bin/make

all: clean fixperms default

allfetch: clean fixperms fetch unpack default

default: default.head default.tail ../return *.sh extras/* protected/* 
	./menu-maker.sh > default

fixperms:
	# make sure perms of protected and all contents are correct
	chmod -R u=rwX,g=,o= ./protected/

clean:
	rm -f default

fetch:
	./fetch-update.sh --latest

unpack:
	./unpack.sh `ls -1t clonezilla-live*.zip | head -n 1`

