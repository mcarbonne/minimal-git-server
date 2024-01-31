#!/bin/bash

set -eu
#shellcheck source=common.sh
. /srv/common.sh

touch /srv/env

echo "REPO_ROOT=/srv/git" > /srv/env
echo "EXTERNAL_HOSTNAME=$(cfg_external_hostname)" >> /srv/env
echo "EXTERNAL_PORT=$(cfg_external_port)" >> /srv/env

chmod 777 /srv/env