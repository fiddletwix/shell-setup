#!/bin/bash

set -e

write() {
    defaults write com.googlecode.iterm2 "$@"
    echo "writing $@"
}

set_defaults() {
    write SUEnableAutomaticChecks -integer 1
    write EnableAPIServer -integer 1
    write FocusFollowsMouse -integer 1
    write UseBorder -integer 1
    write SmartPlacement -integer 1
    # needed to enable touchid sudo
    write BootstrapDaemon -integer 0
}

default_profiles() {
    PROFILE_DIR=${HOME}/Library/Application\ Support/iTerm2/DynamicProfiles
    /bin/mkdir -p "$PROFILE_DIR"
    cp files/iterm2/DynamicProfiles "$PROFILE_DIR"
    echo "Copied Dynamic Profiles to $PROFILE_DIR"
}

python_scripts() {
    AUTOLAUNCH_DIR=${HOME}/Library/Application\ Support/iTerm2/Scripts/AutoLaunch
    /bin/mkdir -p "$AUTOLAUNCH_DIR"
    cp files/iterm2/default-profile.py "$AUTOLAUNCH_DIR"
    echo "Copied Autolaunch Scripts to $AUTOLAUNCH_DIR"
}

main() {
    set_defaults
    default_profiles
    python_scripts
}

main
