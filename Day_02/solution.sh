#!/bin/sh

set -f

input=${1:-input}

while read cmd amount
do  case $cmd in
        f*) ((forward += amount))
            ((depth2  += amount * depth1)) ;;
        d*) ((depth1  += amount))          ;;
        u*) ((depth1  -= amount))          ;;
    esac
done < $input

echo Solution 1: $((forward * depth1))
echo Solution 2: $((forward * depth2))
