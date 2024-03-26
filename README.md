# Docker image for Certbot with Clouflare DNS challenge

Certificates are located in /etc/letsencrypt/

Attempts to renew every 12 hours

### Variables

| Variables              | Description                    |
|------------------------|--------------------------------|
| CLOUDFLARE_API_TOKEN   | Your Cloudflare API token |
| EMAIL                  | Your email associated with certificates |
| DOMAIN                 | Domains for certificate requests, seperated by commas |

### Volumes you'll need to bind
/etc/letsencrypt/

/certs

## Resources

- [certbot-dns-cloudflare’s documentation](https://certbot-dns-cloudflare.readthedocs.io/en/stable/)
