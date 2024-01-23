#!/bin/bash

set -eu
shopt -s nullglob
#shellcheck source=common.sh
. /srv/common.sh

for usercfg in /srv/accounts/*; do
    check_account_format "$usercfg"
    user=$(get_account_user "$usercfg") || die "$user"
    uid=$(get_account_uid "$usercfg") || die "$uid"

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
