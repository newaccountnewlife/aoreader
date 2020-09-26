#!/bin/bash

. ./variables.sh

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

. ./system.sh

. ./networking.sh

. ./packets.sh


while :;do
    aaa
    while read -rd'%' -n 2048 -t10 packet ;do
        handlepacket "${packet}"
        periodically && CL_packet_CH 
    done <&3

    output 'Lost connection to the server. Reconnecting in 5 seconds.'
    sleep 5
done
