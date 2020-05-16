#!/bin/bash

write() {
    defaults write com.blacktree.Quicksilver.plist "$@"
}

set_defaults() {
    write QSAgreementAccepted -integer 1
    write QSActivationHotKey -dict keyCode 49 modifiers 786721
    write QSShowMenuIcon -integer 1
    write "Hide Dock Icon" -integer 0
}

copy_files() {
    QS_DIR=${HOME}/Library/Application\ Support/Quicksilver
    mkdir -p "$QS_DIR"
    cp files/qs/Triggers.plist "$QS_DIR"
}

applescript_scripts() {
    SCRIPTS_DIR=${HOME}/Library/Scripts
    mkdir -p "$SCRIPTS_DIR"
    echo 'tell app "Music" to playpause' > "${SCRIPTS_DIR}"/playpause.txt
    osacompile -o "${SCRIPTS_DIR}"/playpause.scpt "${SCRIPTS_DIR}"/playpause.txt
}

main() {
    set_defaults
    copy_files
}

main
