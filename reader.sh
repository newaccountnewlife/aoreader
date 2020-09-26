#!/bin/bash

clientname="aoreader"
clientversion="0.2"

server="104.131.93.82"
port="27017"

# this is a shitty place to put this
charid="-1"

# use AO from the terminal
# shitty
# you will eventually be thrown out
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
# C: CC
# C: CH
# 
# S: PN
# S: FL
# S: SC
# S: SM
# S: DONE
# S: PV (?)
# S: CHECK
# S: CT
# S: CharsCheck
# 
# 
# 
# Packets yet to implement:
# S: MS (partial)
# S: BN
# S: MC
# S: HP
# S: RT
# S: SP
# S: SD
# S: FM (Music? Areas?)
# S: ARUP
# S: LE
# S: ZZ
# S: KK
# S: KB
# S: BD
# 
# 
# C: MS (partial)
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
	echo "$1"
}

rng() {
	cat /dev/urandom | tr -dc 'a-f0-9' | fold -w "$1"
}
###PROGRAM FUNCTIONS###

###NETWORKING FUNCTIONS###

sendpacket() {
    # this sends packets to the remote AO server
    CL_debugpacket "$1"
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
	charid="$(awk -F# '{print $4}' <<<"$1")"
    output 'Server changed your character to '"$charid"
	
}

SV_packet_CHECK() {
	output 'The connection is still alive.'
}

SV_packet_CharsCheck() {
    output 'Received the Character list.'
	[[ "$charid" == "-1" ]] && findagoodcharacterautomagically "$1"
}

SV_packet_CT() {
    output ''
}

SV_packet_MS() {
	output "$(awk -F# '{print $4"("$5"): "$6}' <<<"$1")"
	
}

SV_packet_XX() {
	return
	
}

CL_packet_CC() {
    sendpacket 'CC#0#'"$1"'#abcdef#%'
	charid="$1"
	
}

CL_packet_CH() {
	sendpacket 'CH#'"${charid}"'#%'
	
}
CL_packet_RC() {
	sendpacket 'RC#%'
	
}

CL_packet_MC() {
	sendpacket 'MC#'"$1"'#'"${charid}"'#'"$2"'#%'
	
}

# placeholder
CL_packet_XX() {
	return
	
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

    elif grep -q -E '^CharsCheck' <<<"$1"; then
         SV_packet_CharsCheck "$1"

    elif grep -q -E '^MS' <<<"$1"; then
         SV_packet_MS "$1"

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
    exec 3<>/dev/tcp/"${server}/${port}" 
}

findagoodcharacterautomagically() {
	output 'Finding a character for you...'
	i=2;
	while :;do
	[[ "$(awk -F# '{print $'"$i"'}' <<<"$1")" == 0 ]] && break
	((i=i+1))
	done
	((i=i-2))
	echo "Character found: $i"
	CL_packet_CC "$i"
}

###NETWORKING FUNCTIONS###
###MAIN###

output "Connecting..."
connect &>/dev/null || die "The connection to the server could not be established. Please check your network and the IP and port of the server."
output "Shaking hands..."
handshake

while read -rd'%' -n 2048 -t10 packet ;do    
    # handle incoming packets
    SV_debugpacket "${packet}"
    handlepacket "${packet}"
done <&3


###MAIN###
