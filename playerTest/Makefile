#########
#
# Makefile pour fonctionTCP
#
#########

# For Solaris
#LD_FLAGS = -lsocket -lnsl

# For Linux
LD_FLAGS =

all: player


fonctionTCP.o: fonctionTCP.c fonctionTCP.h
	gcc -c -o fonctionTCP.o fonctionTCP.c $(LD_FLAGS)

conversion.o: conversion.c conversion.h
	gcc -c -o conversion.o conversion.c $(LD_FLAGS)

printMessageEnum.o: printMessageEnum.c printMessageEnum.h
	gcc -c -o printMessageEnum.o printMessageEnum.c $(LD_FLAGS)

player: player.c fonctionTCP.h fonctionTCP.o conversion.h conversion.o printMessageEnum.h printMessageEnum.o
	gcc player.c -o player fonctionTCP.o conversion.o printMessageEnum.o $(LD_FLAGS)

clean:
	rm *~ ; rm -i \#* ; rm *.o; \
  rm player
