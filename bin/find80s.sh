#!/usr/bin/env sh

if [ -z $2 ]
then
    PORT=80
else
    PORT=$2
fi


nmap -p $PORT $1 | grep -B 4 open
