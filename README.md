# Docker image for Certbot with Clouflare DNS challenge

Certificates will be located at /certs. This will also attempt to renew every 12 hours.

### Variables

| Variables              | Description                    |
|------------------------|--------------------------------|
| CLOUDFLARE_API_TOKEN   | Your Cloudflare API token (DNS edit access) |
| CLOUDFLARE_EMAIL       | Your Cloudflare account email (not recommended) |
| CLOUDFLARE_API_KEY     | Global API Key of your Cloudflare domain (not recommended)  |
| DOMAIN                 | The domain you need the SSL certs for |
| EMAIL                  | Your email                    |

### Volumes
/etc/letsencrypt/
/certs

## Resources

- [certbot-dns-cloudflare’s documentation](https://certbot-dns-cloudflare.readthedocs.io/en/stable/)
