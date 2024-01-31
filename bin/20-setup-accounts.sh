#!/bin/bash

set -eu
#shellcheck source=common.sh
. /srv/common.sh

for ((i=0; i<$(cfg_count_user); i++)); do
    user=$(cfg_get_account_user "$i") || die "$user"

    mkdir -p /home/"$user"/.ssh
    echo "Loading keys for $user"
    safe_cd /home/"$user"
    cfg_get_account_keys "$i" > .ssh/authorized_keys
    chown -R "$user":"$user" .ssh
    chmod 700 .ssh
    chmod -R 600 .ssh/*
done
