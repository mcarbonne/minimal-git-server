#!/bin/bash

#HELP [REPO_NAME] if REPO_NAME exists and is a valid git repository, return 0 otherwise 1

show_usage() {
    echo "Usage: exists REPO_NAME"
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

GIT_REPO="${REPO_ROOT}/$USER/$1"
if is_git_repo "$GIT_REPO"; then
    ok "Repo $1 do exists"
    exit 0
else
    die "Repo $1 do not exist"
fi
