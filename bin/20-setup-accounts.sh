#!/bin/bash

for usercfg in /srv/accounts/*; do
    IFS=":" read -r -a params <<< "$(basename "$usercfg")"
    user=${params[0]}

    mkdir -p /home/"$user"/.ssh
    echo "Loading keys for $user"
    if [ "$(ls -A "$usercfg")" ]; then
        cd /home/"$user" || exit
        cat "$usercfg"/*.pub > .ssh/authorized_keys
    fi
    chown -R "$user":"$user" .ssh
    chmod 700 .ssh
    chmod -R 600 .ssh/*
done
