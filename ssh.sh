#!/bin/bash

set -e

config_ssh() {
    SSH_DIR=${HOME}/.ssh
    mkdir -p "$SSH_DIR"/config.d
    cat <<EOF > ${SSH_DIR}/config
ServerAliveInterval 60
UseKeychain yes

Include config.d/*.conf

# Example ProxyCommand
# ProxyCommand ssh -W %h:%p <bastion>

# Least specific host parameters are specified at the end because ssh will
# use the first instance of a parameter it discovers for a host

Host *
     ConnectTimeout 10
     ForwardAgent no
     ForwardX11Trusted no
     StrictHostKeyChecking no
     UserKnownHostsFile=/dev/null
EOF
}

main() {
    config_ssh
}

main
