#!/usr/bin/env sh

nmap -p 80 $1 | grep -B 4 open
