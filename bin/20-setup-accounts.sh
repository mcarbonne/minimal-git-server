#!/bin/bash

set -eu
#shellcheck source=common.sh
. /srv/common.sh

for usercfg in /srv/accounts/*; do
    check_account_format "$usercfg"
    user=$(get_account_user "$usercfg") || die "$user"

    mkdir -p /home/"$user"/.ssh
    echo "Loading keys for $user"
    safe_cd /home/"$user"
    cat "$usercfg"/*.pub > .ssh/authorized_keys
    chown -R "$user":"$user" .ssh
    chmod 700 .ssh
    chmod -R 600 .ssh/*
done
