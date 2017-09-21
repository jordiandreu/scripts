#!/usr/bin/env bash

dir="/from/here/to/there.txt"
a="$(dirname $dir)"   # Returns "/from/hear/to"
b="$(basename $dir)"
#file="$(filename $dir)"

echo $a
echo $b