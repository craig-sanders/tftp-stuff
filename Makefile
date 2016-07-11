#! /usr/bin/make -f

all: alldef

alldef: defret cz gp
# di

defret:
	./change-ip.sh all

default:
	./change-ip.sh default

return:
	./change-ip.sh return

cz: default
	cd cz ; make

gp: default
	cd gp ; make

di: default
	cd di ; make
