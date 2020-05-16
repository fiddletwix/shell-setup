#!/bin/bash

set -e

main() {
    echo "Symlinking ScreenSaverEngine to /Applications"
    rm -rf /Applications/ScreenSaverEngine.app
    sudo ln -s /System/Library/CoreServices/ScreenSaverEngine.app /Applications/ScreenSaverEngine.app
    echo

    echo "Setting finder to display all files including special and hidden files"
    defaults write com.apple.finder AppleShowAllFiles -string YES && killall Finder
    echo

    SCREENSHOT_DIR=$HOME/Desktop/Screenshots
    mkdir -p $SCREENSHOT_DIR
    echo "Setting Screenshot directory to $SCREENSHOT_DIR"
    defaults write com.apple.screencapture location $SCREENSHOT_DIR
    echo

    TIMEZONE="America/Chicago"
    sudo systemsetup -settimezone $TIMEZONE
    echo

    echo -n "What is the Computer Name: "
    read computername
    sudo systemsetup -setcomputername $computername
    scutil --set HostName $computername
    echo

    set +e
    sudo systemsetup -setremotelogin on
    if [[ $? != 0 ]]; then
	echo
	echo "*** Enabling ssh on the cli failed. This is likely because the terminal you are using needs 'Full Disk Access' ***"
    fi
    set -e
    echo

    echo "Enable Remote Management"
    sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -restart -agent -privs -all
    echo

    set +e
    grep -q pam_tid /etc/pam.d/sudo
    if [[ $? != 0 ]]; then
	set -e
        echo "Enable touchid for sudo"
	# using a neat trick for inserting newline using mac sed
	# https://stackoverflow.com/questions/1421478/how-do-i-use-a-new-line-replacement-in-a-bsd-sed
	sudo sed -i -e '1 s/^/auth       sufficient     pam_tid.so\'$'\n/' /etc/pam.d/sudo
	# Use gsed if the above stops working
	#sudo gsed -i '1 s/^/auth       sufficient     pam_tid.so\n/' /etc/pam.d/sudo
    fi
    set -e

    echo "Autohide the dock and remove autohide delay"
    defaults write com.apple.dock autohide -integer 1
    defaults write com.apple.dock autohide-time-modifier -float 1
    defaults write com.apple.dock no-glass -boolean YES
    killall Dock
}

main
