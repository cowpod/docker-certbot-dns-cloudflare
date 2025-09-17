# Docker image for Certbot with Clouflare DNS challenge


- Compatible with Cloudflare via API Token as of June 30 2024.
- Attempts to renew certificates every 12 hours.
- Supports multiple domains.
- Certificates are placed in /certs, in format [domain].crt (full certificate chain) and [domain].key (private key).
  - Compatible with the [nginx-proxy image](https://github.com/nginx-proxy/nginx-proxy). Refer to [nginx-proxy's SSL Support documentation](https://github.com/nginx-proxy/nginx-proxy/tree/main/docs#ssl-support) for details on how to do this.

## Setup
To get it up and running, first build the image
```bash
docker build -t docker-certbot-dns-cloudflare:latest .
```

then run it with your variables and volumes.
```bash
docker run -d -e CLOUDFLARE_API_TOKEN=YOUR_CLOUDFLARE_API_TOKEN -e EMAIL=YOUR_EMAIL -e DOMAIN=DOMAINS_SEPARATED_BY_COMMAS -v letsencrypt:/etc/letsencrypt -v certs:/certs docker-certbot-dns-cloudflare:latest
```

Or use a compose file as follows, also available in this repository as `compose.yaml`.
```yaml
services:
  certbot:
    build:
      context: .
      dockerfile: Dockerfile
    restart: unless-stopped
    environment:
      - CLOUDFLARE_API_TOKEN=YOUR_CLOUDFLARE_API_TOKEN
      - EMAIL=YOUR_EMAIL
      - DOMAIN=DOMAINS_SEPARATED_BY_COMMAS
    volumes:
      - config:/etc/letsencrypt
      - certs:/certs
      
volumes:
  config:
  certs:
```

And then bring up the container
```bash
docker compose up -d
```

Your certs will be available in the `certs` (or `certbot_certs` for compose) volume, unless you change it to a folder in your home folder such as 
```yaml
      - ~/certs:/certs
```



## Variables

| Variables              | Description                   |
|------------------------|-------------------------------|
| CLOUDFLARE_API_TOKEN   | Your Cloudflare API token     |
| EMAIL                  | Your email                    |
| DOMAIN                 | Domains seperated by commas   |

## Volumes

| Container Path        | Description                    |
|-----------------------|--------------------------------|
| /etc/letsencrypt/     | Required for certbot           |
| /var/lib/letsencrypt/ | Optional                       |
| /var/log/letsencrypt/ | Optional for persistent logging|
| /certs/               | Certs will be placed here      |
