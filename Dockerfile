FROM alpine:latest
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN apk add busybox-openrc sudo

#RUN echo https://dl-cdn.alpinelinux.org/alpine/edge/testing/ >> /etc/apk/repositories && apk update
RUN apk add musl-dev gcc libffi-dev python3-dev

RUN apk add py3-pip && pip install --upgrade --break-system-packages pip
RUN pip install --break-system-packages certbot certbot-dns-cloudflare

RUN apk del musl-dev gcc libffi-dev python3-dev

RUN addgroup -S certbot -g 1000
RUN adduser -SD certbot -h /etc/letsencrypt -u 1000 -G certbot

RUN mkdir -p /var/log/letsencrypt /var/lib/letsencrypt /certs

RUN chown -R certbot:certbot /etc/letsencrypt /var/lib/letsencrypt /var/log/letsencrypt /certs

COPY renew.sh /renew.sh
RUN chmod +x /renew.sh

COPY crontab.conf /crontab.conf
RUN crontab -u certbot /crontab.conf

ENTRYPOINT ["/entrypoint.sh"]

