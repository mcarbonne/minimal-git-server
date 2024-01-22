FROM alpine:3.19

RUN set -eux; \
  apk add --no-cache \
    bash \
    openssh \
    git \
    jq

WORKDIR /srv/

COPY bin bin
COPY conf conf

RUN mkdir -p /srv/accounts
RUN echo -n "" > /etc/motd

ENV EXTERNAL_PORT="2222"
ENV EXTERNAL_HOSTNAME="localhost"

EXPOSE 22

ENTRYPOINT ["bin/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]
