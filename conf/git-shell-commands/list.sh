#!/bin/bash

#HELP list all available repositories

# shellcheck disable=SC1091
. /srv/env
# shellcheck source=git-shell-commands-common.sh
. /srv/git-shell-commands-common.sh


for repo in $(find "$REPO_ROOT/$USER" -name "config" | sort)
do
    folder=$(dirname "$repo")
    repo_name=${folder#"$REPO_ROOT/$USER/"}
    safe_tput setaf 5; echo -en "$repo_name\t"; safe_tput sgr0
    echo "ssh://${USER}@$EXTERNAL_HOSTNAME:$EXTERNAL_PORT${folder}"
done
