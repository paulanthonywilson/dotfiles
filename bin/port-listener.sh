#!/usr/bin/env bash

lsof -nP -i4TCP:$1 | grep LISTEN
