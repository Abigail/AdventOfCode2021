#!/bin/sh

set -f

input=${1:-input}

while read cmd amount
do  case $cmd in
        forward) ((forward += amount))
                 ((depth2  += amount * depth1)) ;;
        down)    ((depth1  += amount))          ;;
        up)      ((depth1  -= amount))          ;;
    esac
done < $input

echo Solution 1: $((forward * depth1))
echo Solution 2: $((forward * depth2))
