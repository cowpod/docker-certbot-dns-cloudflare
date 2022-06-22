#!/bin/ash -l

set -e

if [[ ! -d /etc/letsencrypt/live ]]; then
	echo "Please ensure that /etc/letsencrypt is persistent! Or is this the first run?"
fi

if [[ ! -d /certs ]]; then
        echo "Persistent /certs is required!"
        exit 1
fi

if [[ "${CLOUDFLARE_API_TOKEN}" != "" ]]; then
	echo "CLOUDFLARE_API_TOKEN=${CLOUDFLARE_API_TOKEN}"
	echo "dns_cloudflare_api_token=${CLOUDFLARE_API_TOKEN}" >> ~/cloudflare.ini
else
	echo "CLOUDFLARE_API_TOKEN not set. Trying CLOUDFLARE_EMAIL,CLOUDFLARE_API_KEY"
	if [[ "${CLOUDFLARE_EMAIL}" == "" || "${CLOUDFLARE_API_KEY}" == "" ]]; then
		echo "CLOUDFLARE_EMAIL,CLOUDFLARE_API_KEY variables are not set."
		exit 2
	fi
	echo "CLOUDFLARE_EMAIL=${CLOUDFLARE_EMAIL}"
	echo "CLOUDFLARE_API_KEY=${CLOUDFLARE_API_KEY}"
	echo "dns_cloudflare_email=${CLOUDFLARE_EMAIL}" >> ~/cloudflare.ini
	echo "dns_cloudflare_api_key=${CLOUDFLARE_API_KEY}" >> ~/cloudflare.ini
fi

if [[ "${DOMAIN}" == "" ]]; then
	echo "DOMAIN variable not set."
	exit 3
fi
if [[ "${EMAIL}" == "" ]]; then
	echo "EMAIL variable not set."
	exit 4
fi

certbot certonly --dns-cloudflare --dns-cloudflare-credentials ~/cloudflare.ini -d ${DOMAIN} --non-interactive --agree-tos -m ${EMAIL} | tee /var/log/certbot_status.log

echo "Copying generated certificates to /certs..."

for d in /etc/letsencrypt/live/*; do
	if [[ ! -d "$d" ]]; then
		# not a directory
		continue
	fi

	if [[ ! -f $d/privkey.pem ]]; then
		echo "Couldn't find $d/privkey.pem!"
		exit 5
	fi

	if [[ ! -f $d/fullchain.pem ]]; then
		echo "Couldn't find $d/fullchain.pem!"
		exit 6
	fi

	domain=$(basename $d)
	cp --verbose -L "$d/privkey.pem" "/certs/$domain.key"
	cp --verbose -L "$d/fullchain.pem" "/certs/$domain.crt"
done

echo "Sleeping 12h before running again..."

sleep 12h

/entrypoint.sh

## /etc/letsencrypt/archive
