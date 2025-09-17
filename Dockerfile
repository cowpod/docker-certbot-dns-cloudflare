FROM alpine:latest

RUN addgroup -S certbot -g 1000 \
&& adduser -SD certbot -h /etc/letsencrypt -u 1000 -G certbot

COPY entrypoint.sh /entrypoint.sh
COPY renew.sh /renew.sh
COPY crontab.conf /crontab.conf

RUN chmod +x /renew.sh \
&& chmod +x /entrypoint.sh \
&& crontab -u certbot /crontab.conf

RUN apk add busybox-openrc sudo \
&& apk add musl-dev gcc libffi-dev python3-dev \
&& apk add py3-pip && pip install --upgrade --break-system-packages pip \
&& pip install --break-system-packages certbot certbot-dns-cloudflare \
&& apk del musl-dev gcc libffi-dev python3-dev

RUN mkdir -p /var/log/letsencrypt /var/lib/letsencrypt /certs \
&& chown -R certbot:certbot /etc/letsencrypt /var/lib/letsencrypt /var/log/letsencrypt /certs

ENTRYPOINT ["/entrypoint.sh"]

