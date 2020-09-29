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
    echo -n "$1" >&3 || die "Oops. Couldn't send Packet."; }

handlepacket() {
    packet1="$1"
    # properly matching case is not consistent across bash versions afaik.
    SV_debugpacket "$1"
    
    SV_packets=( 'BD' 'CharsCheck' 'CHECK' 'CT' 
                 'DONE' 'FL' 'KB' 'KK' 'MS' 
                 'PN' 'PV' 'SC' 'SM' 'XX' 'LE'
               )
		   
	for packet_type in "${SV_packets[@]}";do
        [[ "$(getpackettype "${packet1}")" == "${packet_type}" ]] && SV_packet_"${packet_type}" "${packet1}"
	done
}



getpackettype() {
	awk -F'#' '{print $1}'  <<<"$1"
}

handlehandshake() {
    while read -rd'%' -n 4096 packet2 ;do
        [[ "$(getpackettype "${packet2}")" == "decryptor" ]] &&  CL_packet_HI "${hdid}" && CL_packet_ID "${clientname}" "${clientversion}"
        
        case "$(getpackettype "${packet2}")" in

            'PN')
            handlepacket "${packet2}";;

            'FL')
            handlepacket "${packet2}"
            CL_packet_askchaa;;

            'SI')
            handlepacket "${packet2}"
            CL_packet_RC;;

            'SC')
            handlepacket "${packet2}"
            CL_packet_RM;;

            'SM')
            handlepacket "${packet2}"
            CL_packet_RD;;
            
            'HP')
            handlepacket "${packet2}"
            CL_packet_RD;;
                        
            'DONE')
            handlepacket "${packet2}"
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
