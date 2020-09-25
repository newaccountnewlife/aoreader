#!/bin/bash

clientname="aoreader"
clientversion="0.2"

server="104.131.93.82"
port="27017"

# read the official server from the terminal
# shitty
# you will eventually be thrown out, likely
# not a full client yet
#
# TODO:
# pick a character thats not taken
# clean up
# make it a full client
# make everything a function
# implement all packets
# 
# DONE:
# use a socket rather than nc
# properly handshake
# use variables
# 
# Implemented Packets:
# C: HI
# C: ID
# C: RD
# 
# S: PN
# S: FL
# S: SC
# S: SM
# S: DONE
# 
# 
# 
# Packets yet to implement:
# S: PV
# S: CharsCheck
# S: MS
# S: BN
# S: MC
# S: HP
# S: RT
# S: SP
# S: SD
# S: CT
# S: FM (Music? Areas?)
# S: ARUP
# S: LE
# S: ZZ
# 
# 
# C: CC
# C: MS
# C: BN
# C: MC
# C: HP
# C: RT
# C: CT
# C: RE
# C: PE
# C: DE
# C: EE
# C: MC
# C: SETCASE
# C: CASEA
# C: ZZ
# 
# 
# etc. pp.

###PROGRAM FUNCTIONS###

die() {
    # exit the program in case of an error
	echo "$1"
	exit 1
}

output() {
	# output to the user here
}

###PROGRAM FUNCTIONS###

###NETWORKING FUNCTIONS###

sendpacket() {
    # this sends packets to the remote AO server
    echo "$1" >&3 || die "Oops. Couldn't send Packet."
    	
}

handlepacket() {
    # this handles incoming packets
    #
    if grep -E '^PN' <<<"$1"; then
    output 'Players/Max: '"$(awk -F# '{print $1"/"$2}')"
    else
    if grep -E '^FL' <<<"$1"; then
    output 'Features: '"$(tr '#' ', ' <<<"$1")"
    else
    if grep -E '^SC' <<<"$1"; then
    output 'Characters available: '"$(tr '#' ', ' <<<"$1" | tr -d '&')"
    else
    if grep -E '^SM' <<<"$1"; then
    output 'Available Music: '"$(tr '#' ', ' <<<"$1")"
    else
    if grep -E '^DONE' <<<"$1"; then
    output 'Server Done.'
    else
    if grep -E '^SM' <<<"$1"; then
    else
    if grep -E '^SC' <<<"$1"; then
    else
    if grep -E '^SM' <<<"$1"; then
    else
	
}


handshake() {
# handshake

randomhdidlength="30"
hdid="$(cat /dev/random | tr -dc 'a-f0-9' | fold -w ${randomhdidlength})"
handshakestring='HI#'"${hdid}"'#%ID#'"${clientname}"'#'"${clientversion}"'#%RD#%'
sendpacket "${handshakestring}"

}

###NETWORKING FUNCTIONS###

###PACKET FUNCTIONS###

###PACKET FUNCTIONS###

exec 3<>/dev/tcp/"${server}/${port}" || die "The connection to the server could not be established. Please check your network and the IP and port of the server."


while read -r packet;do

# handle incoming packets

done < <(tr '%' '\n' <&3)

# pi=""
# while :;do
    # i="$( <&3 | tr '%' '\n' | tail -1 | grep -E '^MS' | awk -F'#' '{print $4"("$5"): "$6}')"
    # [[ "$pi" != "$i" && "$i" != "" ]] &&
    # echo "$i";pi="$i"
# done
