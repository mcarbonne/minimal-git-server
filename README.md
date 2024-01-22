Originally inspired by https://github.com/jkarlosb/git-server-docker

This container allows to run a minimal git server with a basic CLI to manage repositories.
It supports multiple accounts.

# Minimal configuration

This container requires 3 volumes in order to correctly persist data :
- `/srv/ssh` to persist generated server keys
- `/srv/git` to store repositories
- `/srv/accounts` to setup available accounts, with allowed public keys

```
docker run -v .../ssh:/srv/ssh -v .../git:/srv/git -v .../accounts:/srv/accounts \
        --env EXTERNAL_PORT=20222 --env EXTERNAL_HOSTNAME=xxxx \
        --name minimal-git-server -d -p 20222:22 ghcr.io/mcarbonne/minimal-git-server:latest
```


# /srv/accounts structure

```
user-A:12345
  key_A.pub
user-B:12346
  key_B.pub
shared:12347
  key_A.pub
  key_B.pub
```

For every account, create a folder `username:uid` in /srv/accounts.
Put every public keys allowed to access this account in the created directory.
