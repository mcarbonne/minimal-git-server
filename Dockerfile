FROM alpine:3.19

RUN set -eux; \
  apk add --no-cache \
    bash \
    openssh \
    git \
    yq

WORKDIR /srv/

COPY bin bin
COPY common.sh common.sh
COPY conf conf

RUN echo -n "" > /etc/motd

EXPOSE 22

ENTRYPOINT ["bin/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]
