#!/bin/sh

cd /srv/bin || exit
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

exec "$@"