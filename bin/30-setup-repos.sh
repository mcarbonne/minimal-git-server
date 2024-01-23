#!/bin/bash

set -eu
#shellcheck source=common.sh
. /srv/common.sh

for usercfg in /srv/accounts/*; do
    check_account_format "$usercfg"
    user=$(get_account_user "$usercfg") || die "$user"

    echo "Setting up repos for $user"
    if [ ! -d /srv/git/"$user" ]; then
        echo "Warning: missing repo folder, creating it"
        mkdir -p /srv/git/"$user"
    fi

    chown -R "$user":"$user" /srv/git/"$user"
done
