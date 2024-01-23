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


# Usage
To manage your repositories, simply login to the desired account:
```
$ ssh ACCOUNT@HOSTNAME -p PORT
Availables commands :
 create REPO_NAME : create a git repo
 show REPO_NAME : get clone url
 list : list availables repos

git> list
git> create tests/repo-a
Creating repo tests/repo-a
[ ... ]
Initialized empty Git repository in /srv/git/ACCOUNT/tests/repo-a/
You can now clone it :
git clone ssh://ACCOUNT@HOSTNAME:PORT/srv/git/ACCOUNT/tests/repo-a
git> create tests/repo-b
Creating repo tests/repo-b
[ ... ]
Initialized empty Git repository in /srv/git/ACCOUNT/tests/repo-b/
You can now clone it :
git clone ssh://ACCOUNT@HOSTNAME:PORT/srv/git/ACCOUNT/tests/repo-b
git> create repo-c
Creating repo repo-c
[ ... ]
Initialized empty Git repository in /srv/git/ACCOUNT/repo-c/
You can now clone it :
git clone ssh://ACCOUNT@HOSTNAME:PORT/srv/git/ACCOUNT/repo-c
git> list
repo-c
tests/repo-a
tests/repo-b
git> 

