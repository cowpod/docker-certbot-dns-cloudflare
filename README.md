# Docker image for Certbot with Clouflare DNS challenge

Certificates will be located at /certs. This will also attempt to renew every 12 hours.

### Variables

| Variables              | Description                    |
|------------------------|--------------------------------|
| CLOUDFLARE_EMAIL       | Your Cloudflare account email |
| CLOUDFLARE_API_TOKEN   | Your Cloudflare API token |
| CLOUDFLARE_API_KEY     | Your Cloudflare Global API Key (NOT recommended)  |
| DOMAIN                 | Domains for certificate requests, seperated by commas |
| EMAIL                  | Email for certificate requests |

### Volumes
/etc/letsencrypt/
/certs

## Resources

- [certbot-dns-cloudflare’s documentation](https://certbot-dns-cloudflare.readthedocs.io/en/stable/)
