#!/usr/bin/env bash

if [ "$1" == "" ]; then
  echo "No arguments"
  echo "Usage: `basename $0` <filename to check and fix>"
  exit 1
fi


if [ ! -f $1 ]; then
  echo "$1 does not exist."
  exit 1
fi

i=$1

if diff /dev/null "$i" | tail -1 | grep '^\\ No newline' > /dev/null
then 
  echo "Fixing $i"
  echo >> "$i"
fi
