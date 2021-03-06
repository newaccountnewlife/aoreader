#!/usr/bin/env bash

# packet functions

# incoming
# none of these take args except the packet itself

# PN: outputs the player counts
SV_packet_PN() { output 'Players/Max: '"$(awk -F# '{print $2"/"$3}' <<<"$1")"; }

# FL: outputs all available features
SV_packet_FL() { output 'Features: '"$(tr '#' ', ' <<<"$1")"; }

SV_packet_SC() { output 'Characters available: '"$(tr '#' ', ' <<<"$1" | tr -d '&')"; }

SV_packet_SM() { output 'Available Music: '"$(tr '#' ', ' <<<"$1")"; }

SV_packet_LE() { output 'Available Evidence: '"$(tr '#' ', ' <<<"$1")"; }

SV_packet_DONE() { output 'Server Done.'; isdone="1"; }

SV_packet_CHECK() { output 'The connection is still alive.'; }

SV_packet_PV() { export charid="$(awk -F# '{print $4}' <<<"$1")"
                 output 'Server changed your character to '"$charid"; }


SV_packet_CharsCheck() { output 'Received the Character list.'
                         [[ "$charid" == "-1" ]] && findagoodcharacterautomagically "$1"; }

SV_packet_CT() { output 'OOC: '"$1"; }

SV_packet_MS() { output "$(awk -F# '{print $4"("$5"): "$6}' <<<"$1")"; }

SV_packet_KK() { output 'You have been kicked from the server. Reason:'"$(awk -F# '{print $2}' <<<"$1")"; }

SV_packet_KB() { output 'You have been banned from the server. Reason:'"$(awk -F# '{print $2}' <<<"$1")"; }

SV_packet_BD() { output 'You are banned from the server and cannot join. Reason:'"$(awk -F# '{print $2}' <<<"$1")"; handleban; }

SV_packet_decryptor() { canstart="1"; }
SV_packet_XX() { return; }

# outgoing

# CC: <int charid>
CL_packet_CC() { sendpacket 'CC#0#'"$1"'#abcdef#%'; }

# CH, RC, RD, askchaa: no args
CL_packet_CH() { sendpacket 'CH#'"${charid}"'#%'; }
CL_packet_RC() { sendpacket 'RC#%'; }
CL_packet_RD() { sendpacket 'RD#%'; }
CL_packet_RM() { sendpacket 'RM#%'; }
CL_packet_askchaa() { sendpacket 'askchaa#%'; }

# MC: <string trackname> <string showname>
CL_packet_MC() { sendpacket 'MC#'"$1"'#'"${charid}"'#'"$2"'#%'; }

# HI: <string hdid>
CL_packet_HI() { sendpacket 'HI#'"$1"'#%'; }

# ID: <string clientname> <string version>
CL_packet_ID() { sendpacket 'ID#'"$1"'#'"$2"'#%'; }

# MC: <string trackname> <string showname>
CL_packet_MC() { sendpacket 'MC#'"$1"'#'"$2"'#%'; }
# ZZ: <string reason>
CL_packet_ZZ() { sendpacket 'ZZ#'"$1"'#%'; }

# placeholder
CL_packet_NULL() { sendpacket '\0#%'; }
CL_packet_LF() { sendpacket '\n#%'; }

CL_packet_XX() { return; }
