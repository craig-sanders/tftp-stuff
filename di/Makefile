#! /usr/bin/make

all: clean default

allfetch: clean fetch unpack default

default: default.head default.tail ../return *.sh
	./menu-maker.sh > default

clean:
	rm -f default

fetch:
	./fetch-installer.sh 

unpack:
	./unpack.sh 

fetch-standard:
	./fetch-installer.sh stable amd64
	./fetch-installer.sh stable i386
	./fetch-installer.sh testing amd64
	./fetch-installer.sh testing i386
	./fetch-installer.sh unstable amd64
	./fetch-installer.sh unstable i386

# netboot-stable-amd64.tar.gz
unpack-standard:
	./unpack.sh netboot-stable-amd64.tar.gz
	./unpack.sh netboot-stable-i386.tar.gz
	./unpack.sh netboot-testing-amd64.tar.gz
	./unpack.sh netboot-testing-i386.tar.gz
	./unpack.sh netboot-unstable-amd64.tar.gz
	./unpack.sh netboot-unstable-i386.tar.gz

standard: clean fetch-standard unpack-standard default
