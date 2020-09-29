#!/bin/bash

# sources
. ./variables.sh
. ./system.sh
. ./networking.sh
. ./packets.sh

# use AO from the terminal
# shitty
# you will eventually be thrown out
# not a full client yet
#
# TODO:
# fix the weird output bug (CASEA, CT)
# support MS properly
# implement master server
# store the "hdid" in a file
# clean up
# show showname correctly
# support colors
# show shouts
# implement all packets
# make it a full client
# 
# 
# 
# 
# DONE:
# make everything a function
# pick a character thats not taken
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


while :;do
    bbb
    handlehandshake
    while read -rd'%' -n 4096 packet ;do
#         output "${packet}" "$(getpackettype "${packet}")"
        handlepacket "${packet}"
        periodically && CL_packet_CH # && CL_packet_MC 'Pursuit (DS).opus' 'your fucking mother'
    done <&3
    handledisconnect
done
