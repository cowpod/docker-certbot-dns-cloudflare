FROM alpine:latest
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN echo https://dl-cdn.alpinelinux.org/alpine/edge/testing/ >> /etc/apk/repositories && apk update
RUN apk add musl-dev gcc libffi-dev python3-dev
RUN apk add py3-pip && pip install --upgrade pip
RUN pip install certbot certbot-dns-cloudflare
RUN apk del musl-dev gcc libffi-dev python3-dev
ENTRYPOINT ["/entrypoint.sh"]
