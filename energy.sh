#!/bin/bash

set -e

charger_settings() {
    sudo pmset -c disksleep 0 \
	 sleep 0 \
	 powernap 1 \
	 gpuswitch 2 \
	 standby 1 \
	 halfdim 1 \
	 displaysleep 60 \
	 womp 1
}


battery_settings() {
    sudo pmset -c disksleep 10 \
	 displaysleep 2 \
	 gpuswitch 2 \
	 halfdim 1 \
	 powernap 0 \
	 sleep 1 \
	 standby 1
}

main() {
    charger_settings
    battery_settings
}

main
