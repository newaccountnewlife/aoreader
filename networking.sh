#!/usr/bin/env bash

aaa() {
    output "Shaking hands..."
    handshake
}

bbb() {
    output "Connecting..."
    connect &>/dev/null || die "The connection to the server could not be established. Please check your network and the IP and port of the server."	
}

SV_debugpacket() { output '<~'"$(getpackettype "$1")"; }

CL_debugpacket() { output '~>'"$(getpackettype "$1")"; }

sendpacket() {
    CL_debugpacket "$1"
    echo -en "$1" >&3 || die "Oops. Couldn't send Packet."; }

handlepacket() {
    # properly matching case is not consistent across bash versions afaik.
    packet1="$1"
    SV_debugpacket "${packet1}"
    
    SV_packets=( 'BD' 'CharsCheck' 'CHECK' 'CT' 
                 'decryptor' 'DONE' 'FL' 'KB' 'KK' 'MS' 
                 'PN' 'PV' 'SC' 'SM' 'XX' )
		   
	for packet_type in "${SV_packets[@]}";do
        grep -qE '^'"${packet_type}"'' <<<"${packet1}" && SV_packet_"${packet_type}" "${packet1}" && return 0
	done
	    
    return 1
}



getpackettype() {
	awk -F'#' '{print $1}' <<<"$@"
}

handlehandshake() {
    while read -rd'%' -n 4096 packet ;do
        [[ "$(getpackettype "${packet}")" == "decryptor" ]] &&  CL_packet_HI "${hdid}"
        output wtf
        
        case "$(getpackettype "${packet}")" in
            'ID')
            output a
            CL_packet_ID "${clientname}" "${clientversion}";;

            'PN')
            output b
            handlepacket "${packet}";;

            'FL')
            output c
            handlepacket "${packet}"
            CL_packet_askchaa;;

            'SI')
            output d
            handlepacket "${packet}"
            CL_packet_RC;;

            'SC')
            output e
            handlepacket "${packet}"
            CL_packet_RM;;

            'SM')
            output f
            handlepacket "${packet}"
            CL_packet_RD;;
            
            'HP')
            output g
            handlepacket "${packet}"
            CL_packet_RD;;
                        
            'DONE')
            break;;
            '*')
            output what;break;;
        esac
        
    done <&3
    

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
output 'Handshake finished.'
}

handleban() {
    hdid="$(rng ${randomhdidlength})"
    output="New HDID set."
}
handledisconnect() {
    output 'Lost connection to the server. Reconnecting in 5 seconds.'
    sleep 5
    charid="-1"
    canstart="0"
    isdone="0"
}
