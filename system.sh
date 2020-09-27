#!/usr/bin/env bash
# utility functions
#

die() {
    # exit the program in case of an error
	echo "$1"
	exit 1
}

output() {
	echo "$1"
	# this will be better in the future
}

rng() {
	cat /dev/urandom | tr -dc 'a-f0-9' | fold -w "$1"
}
periodically() {
	[[ "$(bc <<<"$(date +%s)"' % 5')" == "0" ]] ||
	return 1
	
}
