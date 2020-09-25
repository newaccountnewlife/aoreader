#!/bin/bash

clientname="aoreader"
clientversion="0.2"

server="104.131.93.82"
port="27017"

# use AO from the terminal
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
# implement master server
# store the "hdid" in a file
# 
# 
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
# S: PV (?)
# 
# 
# 
# Packets yet to implement:
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
# S: KK
# S: KB
# S: BD
# S: CHECK
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
# C: CH
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
	echo "$1"
}

###PROGRAM FUNCTIONS###

###NETWORKING FUNCTIONS###

sendpacket() {
    # this sends packets to the remote AO server
    echo "$1" >&3 || die "Oops. Couldn't send Packet."
    	
}

###PACKET FUNCTIONS###

SV_packet_PN() {
    output 'Players/Max: '"$(awk -F# '{print $2"/"$3}' <<<"$1")"
	
}
SV_packet_FL() {
    output 'Features: '"$(tr '#' ', ' <<<"$1")"
	
}
SV_packet_SC() {
    output 'Characters available: '"$(tr '#' ', ' <<<"$1" | tr -d '&')"
	
}
SV_packet_SM() {
    output 'Available Music: '"$(tr '#' ', ' <<<"$1")"
	
}
SV_packet_DONE() {
    output 'Server Done.'
	
}

SV_packet_PV() {
    output 'Server changed your character.'
	
}
SV_packet_CHECK() {
	output 'The connection is still alive.'
}
SV_packet_XX() {
	return
}

SV_packet_XX() {
	return
	
}
SV_packet_XX() {
	
	return
}
SV_packet_XX() {
	
	return
}

SV_packet_XX() {
	return
	
}
SV_packet_XX() {
	
	return
}
SV_packet_XX() {
	return
	
}

SV_packet_XX() {
	return
	
}
SV_packet_XX() {
	
	return
}
SV_packet_XX() {
	return
	
}

CL_packet_XX() {
	return
	
}
CL_packet_CH() {
	sendpacket "CH#%"
	
}

###PACKET FUNCTIONS###

SV_debugpacket() {
	output '<~'"$(awk -F# '{print $1}' <<<"$1")"
}

CL_debugpacket() {
	output '~>'"$(awk -F# '{print $1}' <<<"$1")"
}

handlepacket() {
    # this handles incoming packets
    #
      if grep -q -E '^PN' <<<"$1"; then
         SV_packet_PN "$1"

    elif grep -q -E '^FL' <<<"$1"; then
         SV_packet_FL "$1"

    elif grep -q -E '^SC' <<<"$1"; then
         SV_packet_SC "$1"
 
    elif grep -q -E '^SM' <<<"$1"; then
         SV_packet_SM "$1"

    elif grep -q -E '^DONE' <<<"$1"; then
         SV_packet_DONE "$1"

    elif grep -q -E '^CHECK' <<<"$1"; then
         SV_packet_CHECK

    elif grep -q -E '^XX' <<<"$1"; then
         SV_packet_XX "$1"

    elif grep -q -E '^XX' <<<"$1"; then
         SV_packet_XX "$1"
    
    fi
}


handshake() {
# handshake
randomhdidlength="30"
hdid="abcdef"
# hdid="$(cat /dev/urandom | tr -dc 'a-f0-9' | fold -w ${randomhdidlength})"
handshakestring='HI#'"${hdid}"'#%ID#'"${clientname}"'#'"${clientversion}"'#%RD#%'
sendpacket "${handshakestring}" && output "Successful handshake with the server!"

}

connect() {
    exec 3<>/dev/tcp/"${server}/${port}" || die "The connection to the server could not be established. Please check your network and the IP and port of the server."
}
###NETWORKING FUNCTIONS###
###MAIN###

output "Connecting..."
connect
output "Shaking hands..."
handshake

while read -rd'%' -n 2048 -t10 packet ;do
    
    # handle incoming packets
    handlepacket "${packet}"
done <&3

# ignore dis
# pi=""
# while :;do
    # i="$( <&3 | tr '%' '\n' | tail -1 | grep -E '^MS' | awk -F'#' '{print $4"("$5"): "$6}')"
    # [[ "$pi" != "$i" && "$i" != "" ]] &&
    # echo "$i";pi="$i"
# done

###MAIN###
