Originally inspired by https://github.com/jkarlosb/git-server-docker

This container allows to run a minimal git server with a basic CLI to manage repositories.
It supports multiple accounts.

# Minimal configuration

This container requires 3 volumes in order to work:
- `/srv/ssh` to persist generated server keys
- `/srv/git` to store repositories
- `/srv/config.yml` to setup accounts, allowed public keys...

```
docker run -v .../ssh:/srv/ssh -v .../git:/srv/git -v .../config.yml:/srv/config.yml:ro \
        --name minimal-git-server -d -p 20222:22 ghcr.io/mcarbonne/minimal-git-server:latest
```


# config.yml

```yaml
external_hostname: localhost
external_port: 20222
accounts:
  - user: user_a
    id: 12345
    keys:
      - "ssh-rsa XXXXXX user_a@gmail.com"
      - "ssh-rsa XXXXXX user_a@hotmail.com"
  - user: user_b
[...]
```


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

