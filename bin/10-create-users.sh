#!/bin/bash

set -eu
#shellcheck source=common.sh
. /srv/common.sh

for ((i=0; i<$(cfg_count_user); i++)); do
    user=$(cfg_get_account_user "$i") || die "$user"
    uid=$(cfg_get_account_uid "$i") || die "$uid"

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
        die "Fatal, cannot change UID (from $current_uid to $uid). Please re-create container.";
    else
        continue
    fi
done
