# Docker image for Certbot with Clouflare DNS challenge

Certificates are located in /etc/letsencrypt/

Attempts to renew every 12 hours

### Variables

| Variables              | Description                   |
|------------------------|-------------------------------|
| CLOUDFLARE_API_TOKEN   | Your Cloudflare API token     |
| EMAIL                  | Your email                    |
| DOMAIN                 | Domains seperated by commas   |

### Volumes you'll need to bind

| Container Path        | Description                    |
|-----------------------|--------------------------------|
| /etc/letsencrypt/     | Required                       |
| /var/lib/letsencrypt/ | Optional                       |
| /var/log/letsencrypt/ | Optional                       |
| /certs/               | Your certs will be placed here |

## Resources

- [certbot-dns-cloudflare’s documentation](https://certbot-dns-cloudflare.readthedocs.io/en/stable/)
