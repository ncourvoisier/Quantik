#!/bin/sh

if [ "$#" -lt 2 ] || [ "$#" -lt 3 ]; then
	echo "Usage $0 hostServeur portServeur nomJoueur [option]"
	exit 1
fi

if [ "$#" = 3 ]; then
	portIA='2567'
fi

if [ "$#" -gt 3 ]; then
	portIA=$4
fi


make

echo "Launch player with this arguments : $1 $2 $3 \n"

./player $1 $2 $3 B $portIA &

echo "Launch ia : java -jar ia.jar 127.0.0.1 $portIA\n"

java -jar ia.jar 127.0.0.1 $portIA

