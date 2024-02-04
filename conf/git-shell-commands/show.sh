#!/bin/bash

#HELP [REPO_NAME] show clone URL

show_usage() {
    echo "Usage: show REPO_NAME"
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

if ! is_git_repo "$GIT_REPO"; then
    die "Repo $GIT_REPO does not exist"
else
    ok "git clone ssh://${USER}@$EXTERNAL_HOSTNAME:$EXTERNAL_PORT${GIT_REPO}"
fi
