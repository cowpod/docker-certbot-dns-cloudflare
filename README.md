# Docker image for Certbot with Clouflare DNS challenge

Certificates will be located at /certs. This will also attempt to renew every 12 hours.

### Variables

| Variables              | Description                    |
|------------------------|--------------------------------|
| CLOUDFLARE_API_TOKEN   | Your Cloudflare API token |
| EMAIL                  | Your email associated with certificates |
| DOMAIN                 | Domains for certificate requests, seperated by commas |
| SLEEP_INTERVAL         | Time in N[s|m|h] between renewal attempts. Defaults to 12h. |

### Volumes you'll need to bind
/etc/letsencrypt/

/certs

## Resources

- [certbot-dns-cloudflare’s documentation](https://certbot-dns-cloudflare.readthedocs.io/en/stable/)
