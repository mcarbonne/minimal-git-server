#!/bin/bash

#HELP [SOURCE TARGET] rename SOURCE to TARGET. Might either be folders of git repos

show_usage() {
    echo "Usage: rename SOURCE TARGET"
}

# shellcheck disable=SC1091
. /srv/env
# shellcheck source=git-shell-commands-common.sh
. /srv/git-shell-commands-common.sh

if [ $# -ne 2 ]
then
    show_usage
    exit 1
fi

ok "Moving repo $1 to $2"
SRC_FOLDER="${REPO_ROOT}/$USER/$1"
TGT_FOLDER="${REPO_ROOT}/$USER/$2"

if [ -d "$TGT_FOLDER" ]; then
    die "Target already exists, skipped !"
fi

if ! [ -d "$SRC_FOLDER" ]; then
    die "Source do not exist, skipped !"
fi

if ! is_git_repo "$SRC_FOLDER"; then
    warning "Warning, $SRC_FOLDER isn't a git repository"
fi


# TODO: don't allow to move inside another existing repo

mkdir -p "$(dirname "$TGT_FOLDER")"
mv "$SRC_FOLDER" "$TGT_FOLDER"
