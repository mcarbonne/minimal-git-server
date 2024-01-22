#!/bin/bash

for usercfg in /srv/accounts/*; do
    IFS=":" read -r -a params <<< "$(basename "$usercfg")"
    user=${params[0]}
    uid=${params[1]}

    current_uid=$(id -u "$user" 2>/dev/null || echo "0")

    if [[ "$current_uid" == "0" ]]; then
        echo "Creating $user with uid=$uid (current uid=$current_uid)"
        adduser -D -s /usr/bin/git-shell -u "$uid" "$user"

        # sshd does not allow to login if no password is set
        random_pwd=$(cat /proc/sys/kernel/random/uuid)
        echo "$user":"$random_pwd" | chpasswd

        cp -R /srv/conf/git-shell-commands /home/"$user"/git-shell-commands
        chmod -R 755 /home/"$user"/git-shell-commands
    elif [[ "$current_uid" != "$uid" ]]; then
        echo "Fatal, cannot change UID (from $current_uid to $uid). Please re-create container.";
        exit 1
    else
        continue
    fi
done
