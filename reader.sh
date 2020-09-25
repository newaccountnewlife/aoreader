#!/bin/bash

# read the official server from the terminal
# shitty
# you will eventually be thrown out
# not a full client
# 0.1 

nc 104.131.93.82 27017 >>./ao-nh-chat &
pi=""

while :;do
    i="$(cat ./ao-nh-chat | tr '%' '\n' | tail -1 | grep -E '^MS' | awk -F'#' '{print $4"("$5"): "$6}')"
    [[ "$pi" != "$i" && "$i" != "" ]] &&
    echo "$i";pi="$i"  
done
