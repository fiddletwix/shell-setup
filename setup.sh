#!/bin/bash

set -e
dotfiles=".bashrc .bash_profile .bash_login .profile .emacs .emacs.d .gitconfig .gitignore_global"

archive_files() {
    timestamp=$(date +"%F-%T")
    archive=.dotfiles.${timestamp}.tar
    pushd "${HOME}" > /dev/null
    for file in $dotfiles; do
	if [[ -d $file || -f $file ]]; then
	    tar -rf "$archive" $file
	fi
    done
    echo "created archive ${HOME}/${archive}"
    popd > /dev/null
}

symlink_files() {
    this_dir=$(pwd)
    # try to do a sanity check to make sure we're in the right directory
    if [[ -d ${this_dir}/files ]]; then
	for file in $dotfiles; do
	    /bin/rm -rf "${HOME}/$file"
	    ln -s "$this_dir/files/$file" "${HOME}/${file}"
	done
    fi
}

main() {
    archive_files
    symlink_files
}

main
