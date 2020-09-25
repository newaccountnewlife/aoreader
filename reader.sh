#!/bin/bash

# read the official server from the terminal
# shitty
# you will eventually be thrown out
# not a full client
#
# TODO:
# properly handshake
# pick a character thats not taken
# use a socket rather than nc
# clean up
# 
# 0.1 



nc 104.131.93.82 27017 <<<"HI#$(cat/dev/random | tr -dc 'a-f0-9' | fold -w 30)#%ID#aoreader#0.1#%RD#%" >>./ao-nh-chat &
pi=""

while :;do
    i="$(cat ./ao-nh-chat | tr '%' '\n' | tail -1 | grep -E '^MS' | awk -F'#' '{print $4"("$5"): "$6}')"
    [[ "$pi" != "$i" && "$i" != "" ]] &&
    echo "$i";pi="$i"  
done
