#!/bin/bash

set -e
EXEC_DIR=$(dirname $0)

install_brew() {
    if [[ ! -x /usr/local/bin/brew ]]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    fi
}

use_brewfile() {
    echo
    echo "\
About to install software using brew.  Because of the possibility of
requiring sudo privs, do not leave this install unattended"
    echo "Press Enter to continue"
    read EMPTY
    echo
    brew bundle --file ${EXEC_DIR}/files/Brewfile
    echo
    echo "if this is a home machine run this command:"
    echo
    echo "brew bundle --file ${EXEC_DIR}/files/Brewfile.home"
}

xcode_calls() {
    sudo xcodebuild -license accept
}

main() {
    install_brew
    use_brewfile
    xcode_calls
}

main
