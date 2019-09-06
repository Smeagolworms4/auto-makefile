#!/bin/sh
[ ! -f $2/$3 ] && curl -L --silent -f $1/$3 -o $2/$3