FROM alpine:3.20.3

RUN set -eux; \
  apk add --no-cache \
    bash \
    openssh \
    git \
    yq-go \
    ncurses

WORKDIR /srv/

COPY bin bin
COPY common.sh common.sh
COPY git-shell-commands-common.sh git-shell-commands-common.sh
COPY conf conf

RUN echo -n "" > /etc/motd

EXPOSE 22

ENTRYPOINT ["bin/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]
