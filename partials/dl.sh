#!/bin/sh
[ ! -f $2/$3 ] && curl --silent -f $1/$3 -o $2/$3