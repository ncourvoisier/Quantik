#!/bin/sh

if [ "$#" -lt 2 ] || [ "$#" -lt 3 ]; then
	echo "Usage $0 hostServeur portServeur nomJoueur [option]"
	exit 1
fi

make
javac *.java


echo "Launch player with this arguments : $1 $2 $3 $4\n"

./player $1 $2 $3 B $4

#./quantikServeur 2560
#./player 127.0.0.1 2560 Nico B 2566
#java EnginIA 127.0.0.1 2566
