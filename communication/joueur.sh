#!/bin/sh

if [ "$#" -lt 2 ] || [ "$#" -lt 3 ]; then
	echo "Usage $0 hostServeur portServeur nomJoueur [option]"
	exit 1
fi

make

echo "Launch player with this arguments : $1 $2 $3 \n"

./player $1 $2 $3 B 2567

