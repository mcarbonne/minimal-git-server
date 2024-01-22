#!/bin/sh

if [ -L /etc/ssh ]; then
    echo "SSH already configured, skipping"
else
    cp -R /etc/ssh /srv/ssh
    rm -fr /etc/ssh
    ln -s /srv/ssh /etc/ssh

    cp /srv/conf/sshd_config /srv/ssh/sshd_config

    ssh-keygen -A
fi