#!/bin/sh

set -eu

cat > /srv/conf/git-shell-commands/help << EOM
#!/bin/bash

#shellcheck disable=SC1091
. /srv/env
#shellcheck source=git-shell-commands-common.sh
. /srv/git-shell-commands-common.sh

echo "Availables commands :"
EOM

for file in /srv/conf/git-shell-commands/*.sh
do
    cmd="${file%.*}"
    echo "$file => $cmd"
    help=$(grep "#HELP" < "$file"| sed 's/#HELP //g' || echo " - ")
    printf "safe_tput setaf 4; echo -en \"%s:\t\"; safe_tput sgr0;\n" >> /srv/conf/git-shell-commands/help "$(basename "$cmd")"
    printf "echo -e \"%s\"\n" >> /srv/conf/git-shell-commands/help "$help"
    mv "$file" "${file%.*}"
done

cat >> /srv/conf/git-shell-commands/help << EOM
echo
EOM
