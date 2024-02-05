#!/bin/bash

#HELP [TARGET] remove TARGET directory/repo

show_usage() {
    echo "Usage: remove TARGET"
}

# shellcheck disable=SC1091
. /srv/env
# shellcheck source=git-shell-commands-common.sh
. /srv/git-shell-commands-common.sh

if [ $# -ne 1 ]
then
    show_usage
    exit 1
fi

warning "Deleting $1"
TARGET_FOLDER="${REPO_ROOT}/$USER/$1"

if ! [ -d "$TARGET_FOLDER" ]
then
    die "Target do not exist, skipped !"
fi


# TODO: add confirmation

rm -fr "$TARGET_FOLDER"
