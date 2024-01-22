#!/bin/bash

touch /srv/env

echo "REPO_ROOT=/srv/git" > /srv/env
echo "EXTERNAL_HOSTNAME=$EXTERNAL_HOSTNAME" >> /srv/env
echo "EXTERNAL_PORT=$EXTERNAL_PORT" >> /srv/env

chmod 777 /srv/env