#!/bin/bash

set -e

execute_cmd()
{
    echo "Executing $*"
    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 20222 git@localhost "$*"
}

expect_pass()
{
    if "$@" > /dev/null 2>&1; then
        echo -en "$*\t"; tput setaf 2; echo "OK"; tput sgr0
    else
        echo -en "$*\t"; tput setaf 1; echo "KO"; tput sgr0
        exit 1
    fi
}

expect_fail()
{
    if ! "$@" > /dev/null 2>&1; then
        echo -en "$*\t"; tput setaf 2; echo "OK"; tput sgr0
    else
        echo -en "$*\t"; tput setaf 1; echo "KO"; tput sgr0
        exit 1
    fi
}

test_folder=$(mktemp -d)
echo "test folder: $test_folder"
mkdir "$test_folder/ssh"
mkdir "$test_folder/git"

cat > "$test_folder/config.yml" << EOM
external_hostname: localhost
external_port: 20222
accounts:
  - user: git
    uid: 4000
    keys:
EOM
echo "      - \"$(cat ~/.ssh/id_rsa.pub)\"" >> "$test_folder/config.yml"



docker stop test-minimal-git-server > /dev/null 2>&1 || true
docker rm test-minimal-git-server > /dev/null 2>&1 || true

docker build -t test-minimal-git-server .
docker run -v "${test_folder}"/ssh:/srv/ssh -v "${test_folder}"/git:/srv/git -v "${test_folder}"/config.yml:/srv/config.yml:ro \
        --name test-minimal-git-server -d -p 20222:22 test-minimal-git-server


sleep 5 # wait container to be ready

expect_pass execute_cmd "create abc123"
expect_fail execute_cmd "create abc123" # test cannot override
expect_pass execute_cmd "exists abc123"

# test rename
expect_pass execute_cmd "rename abc123 abc456"
expect_fail execute_cmd "exists abc123"
expect_pass execute_cmd "exists abc456"

# test rename to subfolder
expect_pass execute_cmd "rename abc456 toto/abc456"
expect_fail execute_cmd "exists abc456"
expect_pass execute_cmd "exists toto/abc456"
expect_pass execute_cmd "show toto/abc456"
expect_fail execute_cmd "show toto"
expect_fail execute_cmd "show 123"

# test remove
expect_pass execute_cmd "remove toto/abc456"
expect_fail execute_cmd "exists toto/abc456"


# test remove parent folder
expect_pass execute_cmd "create toto/abc/123"
expect_pass execute_cmd "remove toto"
expect_fail execute_cmd "exists toto/abc/123"


tput setaf 2; echo "All test OK"; tput sgr0