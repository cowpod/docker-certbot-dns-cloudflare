# Docker image for Certbot with Clouflare DNS challenge


- Compatible with Cloudflare via API Token as of June 30 2024.
- Attempts to renew certificates every 12 hours.
- Supports multiple domains.
- Certificates are placed in /certs, in format [domain].crt (full certificate chain) and [domain].key (private key).
  - Compatible with the [nginx-proxy image](https://github.com/nginx-proxy/nginx-proxy). Refer to [nginx-proxy's SSL Support documentation](https://github.com/nginx-proxy/nginx-proxy/tree/main/docs#ssl-support) for details on how to do this.

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
