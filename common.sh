#!/bin/bash

safe_tput()
{
    if [[ -t 1 ]]; then
        tput "$@"
    fi
}

die() { safe_tput setaf 1; echo "fatal: $*"; safe_tput sgr0; exit 1; }

safe_cd()
{
    cd "$1" || die "$1 not found"
}

cfg_count_user()
{
    yq ".accounts | length" /srv/config.yml
}

cfg_get_account_user()
{
    local index="$1"
    local user
    user=$(yq ".accounts[$index].user" /srv/config.yml)
    if [[ "$user" =~ ^[a-z][-a-z0-9_]*$ ]]; then
        echo "$user"
    else
        die "Illegal user '$user'"
    fi
}

cfg_get_account_uid()
{
    local index="$1"
    local uid
    uid=$(yq ".accounts[$index].uid" /srv/config.yml)
    case $uid in
        ''|*[!0-9]*) die "Illegal uid '$uid'" ;;
        *) echo "$uid";;
    esac
}

cfg_get_account_keys()
{
    local index="$1"
    yq '.accounts['"$index"'].keys | join("\n")' /srv/config.yml
}

cfg_external_hostname()
{
    yq '.external_hostname' /srv/config.yml
}

cfg_external_port()
{
    yq '.external_port' /srv/config.yml
}
