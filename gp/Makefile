#! /usr/bin/make

all: clean default

allfetch: clean fetch unpack default

default: default.head default.tail ../return *.sh
	./menu-maker.sh > default

clean:
	rm -f default

fetch:
	./fetch-update.sh --latest

unpack:
	./unpack.sh `ls -1t gparted-live*.zip | head -n 1`

