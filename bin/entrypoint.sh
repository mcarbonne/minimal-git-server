#!/bin/bash

set -eu
shopt -s nullglob
#shellcheck source=common.sh
. /srv/common.sh

safe_cd /srv/bin

myself=$(basename "$0")

for file in *
do
  case "$file" in
    "$myself"):
      ;;
    *)
      echo "Executing $file"; "./${file}" ;;
  esac
done

echo "Starting '$*'"
exec "$@"
