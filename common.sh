#!/bin/bash

die() { echo "fatal: $*"; exit 1; }

safe_cd()
{
    cd "$1" || die "$1 not found"
}

check_account_format()
{
    local usercfg="$1"
    local params
    IFS=":" read -r -a params <<< "$(basename "$usercfg")"
    if [ "${#params[@]}" -ne 2 ]; then
        die "Bad format for account $usercfg"
    fi
}

get_account_user()
{
    local usercfg="$1"
    local params
    IFS=":" read -r -a params <<< "$(basename "$usercfg")"
    echo "${params[0]}"
}

get_account_uid()
{
    local usercfg="$1"
    local params
    IFS=":" read -r -a params <<< "$(basename "$usercfg")"
    local uid=${params[1]}
    case $uid in
        ''|*[!0-9]*) die "Illegal uid '$uid'" ;;
        *) echo "$uid";;
    esac
}
