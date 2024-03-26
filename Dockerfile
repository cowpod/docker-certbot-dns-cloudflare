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

RUN chown -R certbot:certbot /etc/letsencrypt

COPY crontab.conf /crontab.conf
RUN crontab -u certbot /crontab.conf

RUN mkdir -p /var/log/letsencrypt
RUN chown -R certbot:certbot /var/log/letsencrypt

RUN mkdir -p /var/lib/letsencrypt
RUN chown -R certbot:certbot /var/lib/letsencrypt

RUN chown -R certbot:certbot /etc/letsencrypt /var/lib/letsencrypt /var/log/letsencrypt

ENTRYPOINT ["/entrypoint.sh"]

