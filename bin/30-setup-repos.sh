#!/bin/bash

for usercfg in /srv/accounts/*; do
    IFS=":" read -r -a params <<< "$(basename "$usercfg")"
    user=${params[0]}

    echo "Setting up repos for $user"
    if [ ! -d /srv/git/"$user" ]; then
        echo "Warning: missing repo folder, creating it"
        mkdir -p /srv/git/"$user"
    fi

    chown -R "$user":"$user" /srv/git/"$user"
done
