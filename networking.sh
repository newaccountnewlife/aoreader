#!/usr/bin/env bash

aaa() {
    output "Connecting..."
    connect &>/dev/null || die "The connection to the server could not be established. Please check your network and the IP and port of the server."
    output "Shaking hands..."
    handshake
}

SV_debugpacket() { output '<~'"$(awk -F# '{print $1}' <<<"$1")"; }

CL_debugpacket() { output '~>'"$(awk -F# '{print $1}' <<<"$1")"; }

sendpacket() {
    CL_debugpacket "$1"
    echo "$1" >&3 || die "Oops. Couldn't send Packet."; }

handlepacket() {
    # properly matching case is not consistent across bash versions afaik.
    
    SV_debugpacket "${packet}"
    
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

    elif grep -q -E '^KK' <<<"$1"; then
         SV_packet_XX "$1"

    elif grep -q -E '^XX' <<<"$1"; then
         SV_packet_XX "$1"
         
    else return 1
    fi
}


handshake() {
randomhdidlength="30"

# hdid="$(rng ${randomhdidlength})"
hdid="abcdef"

CL_packet_HI "${hdid}" &&
CL_packet_ID "${clientname}" "${clientversion}" &&
output 'Handshake sent.'
}

connect() { exec 3<>/dev/tcp/"${server}/${port}"; }

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
	CL_packet_RD
}

handleban() {
    hdid="$(rng ${randomhdidlength})"
    output="New HDID set."
}
